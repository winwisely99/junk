// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../src/index/document.dart';
import '../../src/index/index_reader.dart';
import '../../src/search/index_searcher.dart';
import '../../src/search/query.dart';
import '../../src/store/index_directory.dart';
import '../../src/store/standard/composite_index_directory.dart';

/// An IndexWriter creates and maintains an index segment.
///
/// For multiple segments, use IndexHolder.
class IndexWriter {
  final IndexDirectory _directory;

  IndexWriter(this._directory);

  Future<Null> write(Iterable<Document> documents) async {
    final IndexWriteModel model = buildModel(documents);
    await writeModel(model);
  }

  Future<Null> writeModel(IndexWriteModel model) async {
    await _directory.initOutput();
    await _writeIndexInfo(model.indexInfo);
    await _writeLiveDocs(model.liveDocs);
    await _writeIndexes(model.indexes);
    await _writeData(model.data);
  }

  IndexWriteModel buildModel(Iterable<Document> documents) {
    final IndexWriteModel model = new IndexWriteModel();
    int docId = 0;
    for (Document doc in documents) {
      _buildModel(docId, doc, model);
      docId++;
    }
    return model;
  }

  void _buildModel(int docId, Document document, IndexWriteModel model) {
    model.indexInfo.addDoc();
    model.liveDocs.append(docId);
    for (Field field in document.fields) {
      final String name = field.name;
      final List<String> text = field.text;
      final Iterable<Iterable<String>> tokensIte =
          new Iterable<Iterable<String>>.generate(
              text.length, (int i) => field.analyzer.getTokens(text[i]));
      final Iterable<String> tokens =
          tokensIte.expand((Iterable<String> x) => x);
      if (!model.indexes.containsKey(name)) {
        model.indexes[name] = new InvertedIndexBuilder().append(tokens, docId);
      } else {
        model.indexes[name].append(tokens, docId);
      }
      if (field.stored) {
        if (!model.data.containsKey(name)) {
          model.data[name] = new StoredDataBuilder().append(docId, text);
        } else {
          model.data[name].append(docId, field.text);
        }
      }
    }
  }

  Future<Null> _writeIndexInfo(IndexInfoBuilder indexInfo) async {
    await _directory.outputIndexInfo(indexInfo.build());
  }

  Future<Null> _writeLiveDocs(LiveDocsBuilder liveDocs) async {
    await _directory.outputLiveDocs(liveDocs.build());
  }

  Future<Null> _writeIndexes(Map<String, InvertedIndexBuilder> indexes) async {
    for (String name in indexes.keys) {
      await _directory.outputIndex(name, indexes[name].build());
    }
  }

  Future<Null> _writeData(Map<String, StoredDataBuilder> data) async {
    for (String name in data.keys) {
      await _directory.outputData(name, data[name].build());
    }
  }

  Future<Null> delete(BoolQuery query) async {
    final IndexReader reader = await DirectoryReader.open(_directory);
    final IndexSearcher searcher = new IndexSearcher(reader);
    final TopDocs hits = await searcher.search(query, await reader.maxDoc(),
        scoreSort: new NoOpScoreSort());
    if (hits.totalHits > 0) {
      final IDocSet liveDocs = await reader.liveDocs();
      final IDocSet newLiveDocs = liveDocs.not(hits.docSet);
      await _directory.outputLiveDocs(newLiveDocs);
    }
  }

  Future<Null> expungeDeletes() async {
    final Map<int, int> diffNumbers = <int, int>{};

    final IDocSet liveDocs = IDocSet.empty();
    await _directory.inputLiveDocs().read(liveDocs);

    final Iterable<int> docIds = liveDocs.toIterable();
    int i = 0;
    for (int docId in docIds) {
      diffNumbers[docId] = docId - i;
      i++;
    }

    final Set<int> newDocIds =
        new Iterable<int>.generate(diffNumbers.length, (int i) => i).toSet();
    final IDocSet newLiveDocs =
        IDocSet.newDocSetFromSet(newDocIds, newDocIds.length);

    final Index indexes = Index.empty();
    await _directory.inputIndex().read(indexes);
    final Index updatedIndexes = Index.empty();
    expungeDeletesForIndexes(indexes, updatedIndexes, liveDocs);

    final Index newIndexes = Index.empty();
    for (String field in updatedIndexes.keys) {
      final Map<String, IDocSet> newIndex = Index.emptyTermDictionary();
      final Map<String, IDocSet> index = updatedIndexes[field];
      for (String term in index.keys) {
        final Set<int> newDocIds = new Set<int>();
        for (int docId in index[term].toIterable()) {
          final int diff = diffNumbers[docId];
          final int newDocId = docId - diff;
          newDocIds.add(newDocId);
        }
        final IDocSet newDocSet =
            IDocSet.newDocSetFromSet(newDocIds, newLiveDocs.docCount());
        newIndex[term] = newDocSet;
      }
      newIndexes[field] = newIndex;
    }

    final FieldData data = FieldData.empty();
    await _directory.inputData().read(data);
    final FieldData updatedData = FieldData.empty();
    expungeDeletesForData(data, updatedData, liveDocs);

    final FieldData newData = FieldData.empty();
    for (String field in updatedData.keys) {
      final Map<int, DocData> newDocs = FieldData.emptyDocValues();
      final Map<int, DocData> docs = updatedData[field];
      for (int docId in docs.keys) {
        final int diff = diffNumbers[docId];
        final int newDocId = docId - diff;
        newDocs[newDocId] = updatedData[field][docId];
      }
      newData[field] = newDocs;
    }

    final IndexInfo indexInfo = IndexInfo.empty();
    indexInfo.setMaxDoc(newLiveDocs.docCount());

    await _directory.initOutput();
    await _directory.outputIndexInfo(indexInfo);
    await _directory.outputLiveDocs(newLiveDocs);
    for (String field in newIndexes.keys) {
      await _directory.outputIndex(field, newIndexes[field]);
    }
    for (String field in newData.keys) {
      await _directory.outputData(field, newData[field]);
    }
  }

  static void expungeDeletesForIndexes(
      Index currentIndexes, Index newIndexes, IDocSet liveDocs) {
    for (String field in currentIndexes.keys) {
      final Map<String, IDocSet> newIndex = Index.emptyTermDictionary();
      final Map<String, IDocSet> index = currentIndexes[field];
      for (String term in index.keys) {
        final IDocSet newDocs = index[term].and(liveDocs);
        if (newDocs.docCount() > 0) {
          newIndex[term] = newDocs;
        }
      }
      newIndexes[field] = newIndex;
    }
  }

  static void expungeDeletesForData(
      FieldData currentData, FieldData newData, IDocSet liveDocs) {
    final Set<int> liveDocSetIds = liveDocs.toIterable().toSet();
    for (String field in currentData.keys) {
      final Map<int, DocData> newDocs = FieldData.emptyDocValues();
      final Map<int, DocData> curDocs = currentData[field];
      for (int docId in curDocs.keys) {
        if (liveDocSetIds.contains(docId)) {
          newDocs[docId] = curDocs[docId];
        }
      }
      newData[field] = newDocs;
    }
  }

  static Future<Null> copyFrom(
      CompositeIndexDirectory from, IndexDirectory to) async {
    await to.initOutput();
    final IndexInfo indexInfo = IndexInfo.empty();
    await from.inputIndexInfo().read(indexInfo);
    await to.outputIndexInfo(indexInfo);
    final IDocSet liveDocs = IDocSet.empty();
    await from.inputLiveDocs().read(liveDocs);
    await to.outputLiveDocs(liveDocs);
    final Index indexes = Index.empty();
    await from.inputIndex().read(indexes);
    for (String field in indexes.keys) {
      await to.outputIndex(field, indexes[field]);
    }
    final FieldData data = FieldData.empty();
    await from.inputData().read(data);
    for (String field in data.keys) {
      await to.outputData(field, data[field]);
    }
  }
}

class IndexWriteModel {
  IndexInfoBuilder indexInfo = new IndexInfoBuilder();
  LiveDocsBuilder liveDocs = new LiveDocsBuilder();
  Map<String, InvertedIndexBuilder> indexes = <String, InvertedIndexBuilder>{};
  Map<String, StoredDataBuilder> data = <String, StoredDataBuilder>{};
}

class IndexInfoBuilder {
  int _maxDoc = 0;

  IndexInfoBuilder addDoc() {
    _maxDoc++;
    return this;
  }

  IndexInfo build() {
    final Map<String, String> info = <String, String>{};
    info['maxDoc'] = _maxDoc.toString();
    return new IndexInfo(info);
  }
}

class LiveDocsBuilder {
  final Set<int> _liveDocs = new Set<int>();

  LiveDocsBuilder append(int docId) {
    _liveDocs.add(docId);
    return this;
  }

  IDocSet build() {
    final int maxDoc = _liveDocs.length;
    return IDocSet.newDocSetFromSet(_liveDocs, maxDoc);
  }
}

class InvertedIndexBuilder {
  final Map<String, Set<int>> _invertedIndex = <String, Set<int>>{};
  int _maxDoc = 0;

  InvertedIndexBuilder append(Iterable<String> tokens, int docId) {
    for (String token in tokens) {
      if (!_invertedIndex.containsKey(token)) {
        final Set<int> docIds = new Set<int>()..add(docId);
        _invertedIndex[token] = docIds;
      } else {
        final Set<int> docIds = _invertedIndex[token];
        if (!docIds.contains(docId)) {
          docIds.add(docId);
        }
      }
    }
    _maxDoc++;
    return this;
  }

  Map<String, IDocSet> build() {
    final Map<String, IDocSet> ret = <String, IDocSet>{};
    final List<String> terms = _invertedIndex.keys.toList();
    terms.sort();
    for (String term in terms) {
      ret[term] =
          IDocSet.newDocSetFromSet(_invertedIndex[term].toSet(), _maxDoc);
    }
    return ret;
  }
}

class StoredDataBuilder {
  final Map<int, DocData> _storedData = <int, DocData>{};

  StoredDataBuilder append(int docId, List<String> text) {
    _storedData[docId] = new DocData(text);
    return this;
  }

  Map<int, DocData> build() {
    return _storedData;
  }
}
