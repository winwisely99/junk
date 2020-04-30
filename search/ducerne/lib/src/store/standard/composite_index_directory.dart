// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../../src/index/index_reader.dart';
import '../../../src/store/index_directory.dart';

/// Implements [IndexDirectory] composed of multiple [IndexDirectory] implementations.
class CompositeIndexDirectory implements IndexDirectory {
  final List<IndexDirectory> _directories;
  CompositeIndexDirectory(this._directories);

  @override
  Future<Null> initOutput() async {}

  @override
  Future<Null> outputIndexInfo(IndexInfo info) async {
    throw new Exception('UnsupportedOperationException');
  }

  @override
  Future<Null> outputLiveDocs(IDocSet docIds) {
    throw new Exception('UnsupportedOperationException');
  }

  @override
  Future<Null> outputIndex(String name, Map<String, IDocSet> index) {
    throw new Exception('UnsupportedOperationException');
  }

  @override
  Future<Null> outputData(String name, Map<int, DocData> data) {
    throw new Exception('UnsupportedOperationException');
  }

  @override
  void initInput() {}

  @override
  IndexInfoSource inputIndexInfo() =>
      new IndexInfoSource(new CompositeIndexInfoStreams(_directories));

  @override
  LiveDocsSource inputLiveDocs() =>
      new LiveDocsSource(new CompositeLiveDocsStreams(_directories));

  @override
  IndexSource inputIndex() =>
      new IndexSource(new CompositeIndexStreams(_directories));

  @override
  DataSource inputData() =>
      new DataSource(new CompositeDataStreams(_directories));
}

class CompositeIndexInfoStreams extends IndexInfoStreams {
  final List<IndexDirectory> _directories;
  CompositeIndexInfoStreams(this._directories);
  @override
  Future<Null> readFully(IndexInfo to) async {
    int maxDoc = 0;
    for (IndexDirectory directory in _directories) {
      final IndexInfo info = IndexInfo.empty();
      await directory.inputIndexInfo().read(info);
      final int curMaxDoc = info.getMaxDoc();
      maxDoc += curMaxDoc;
    }
    final Map<String, String> map = <String, String>{
      'maxDoc': maxDoc.toString(),
    };
    to.updateFromMap(map);
  }
}

class CompositeLiveDocsStreams extends LiveDocsStreams {
  final List<IndexDirectory> _directories;
  CompositeLiveDocsStreams(this._directories);
  @override
  Future<Null> readFully(IDocSet to) async {
    final Set<int> ret = new Set<int>();
    int prevMaxDoc = 0;
    for (IndexDirectory directory in _directories) {
      final IDocSet docSet = IDocSet.empty();
      await directory.inputLiveDocs().read(docSet);
      final Set<int> docIds = docSet.toIterable().toSet();
      merge(ret, docIds, prevMaxDoc);
      final IndexInfo info = IndexInfo.empty();
      await directory.inputIndexInfo().read(info);
      final int maxDoc = info.getMaxDoc();
      prevMaxDoc += maxDoc;
    }
    to.updateFromSet(ret, prevMaxDoc);
  }

  static void merge(Set<int> to, Set<int> from, int max) {
    to.addAll(from.map((int docId) => docId + max).toSet());
  }
}

class CompositeIndexStreams extends IndexStreams {
  final List<IndexDirectory> _directories;
  CompositeIndexStreams(this._directories);
  bool _readFully = false;
  @override
  Future<Null> readFully(Index to) async {
    _readFully = true;
    final Index ret = Index.empty();
    int prevMaxDoc = 0;
    for (IndexDirectory directory in _directories) {
      final Index indexes = Index.empty();
      await directory.inputIndex().read(indexes);
      final IndexInfo info = IndexInfo.empty();
      await directory.inputIndexInfo().read(info);
      final int maxDoc = info.getMaxDoc();
      merge(ret, indexes, prevMaxDoc, maxDoc);
      prevMaxDoc += maxDoc;
    }
    final int latestMaxDoc = prevMaxDoc;
    resize(ret, to, latestMaxDoc);
  }

  static void merge(Index to, Index from, int curMax, int max) {
    for (String field in from.keys) {
      if (to[field] == null) {
        to[field] = Index.emptyTermDictionary();
      }
      final Map<String, IDocSet> index = from[field];
      for (String term in index.keys) {
        final Set<int> newDocIds =
            index[term].toIterable().map((int id) => id + curMax).toSet();
        if (to[field][term] == null) {
          to[field][term] = IDocSet.newDocSetFromSet(newDocIds, curMax + max);
        } else {
          final Set<int> cur = to[field][term].toIterable().toSet();
          cur.addAll(newDocIds);
          to[field][term] = IDocSet.newDocSetFromSet(cur, curMax + max);
        }
      }
    }
  }

  static void resize(Index from, Index to, int length) {
    for (String field in from.keys) {
      final Map<String, IDocSet> index = Index.emptyTermDictionary();
      for (String term in from[field].keys) {
        final Set<int> newDocIds = from[field][term].toIterable().toSet();
        index[term] = IDocSet.newDocSetFromSet(newDocIds, length);
      }
      to[field] = index;
    }
  }

  @override
  Future<Null> readTerms(String field, Index to) async {
    if (!_readFully) await readFully(to);
  }

  @override
  Future<Null> readPostings(String field, String term, Index to) async {
    if (!_readFully) await readFully(to);
  }
}

class CompositeDataStreams extends DataStreams {
  final List<IndexDirectory> _directories;
  CompositeDataStreams(this._directories);
  bool _readFully = false;
  @override
  Future<Null> readFully(FieldData to) async {
    _readFully = true;
    final FieldData ret = FieldData.empty();
    int prevMaxDoc = 0;
    for (IndexDirectory directory in _directories) {
      final FieldData data = FieldData.empty();
      await directory.inputData().read(data);
      merge(ret, data, prevMaxDoc);
      final IndexInfo info = IndexInfo.empty();
      await directory.inputIndexInfo().read(info);
      final int maxDoc = info.getMaxDoc();
      prevMaxDoc += maxDoc;
    }
    for (String field in ret.keys) {
      to[field] = ret[field];
    }
  }

  static void merge(FieldData to, FieldData from, int max) {
    for (String field in from.keys) {
      if (to[field] == null) {
        to[field] = from[field];
        continue;
      }
      final Map<int, DocData> docs = from[field];
      for (int docId in docs.keys) {
        final int newDocIds = docId + max;
        to[field][newDocIds] = docs[docId];
      }
    }
  }

  @override
  Future<Null> readFields(FieldData to) async {
    if (!_readFully) await readFully(to);
  }

  @override
  Future<Null> readValues(String field, int docId, FieldData to) async {
    if (!_readFully) await readFully(to);
  }
}
