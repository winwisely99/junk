// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import '../../../src/index/index_reader.dart';
import '../../../src/store/index_directory.dart';

class URLIndexDirectory implements IndexDirectory {
  final String _url;
  final List<String> _indexFields;
  final List<String> _storedFields;
  URLIndexDirectory(this._url, this._indexFields, this._storedFields);

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
      new IndexInfoSource(new URLIndexInfoStreams(_url));

  @override
  LiveDocsSource inputLiveDocs() =>
      new LiveDocsSource(new URLLiveDocsStreams(_url));

  @override
  IndexSource inputIndex() =>
      new IndexSource(new URLIndexStreams(_indexFields, _url));

  @override
  DataSource inputData() =>
      new DataSource(new URLDataStreams(_storedFields, _url));
}

class URLIndexInfoStreams extends IndexInfoStreams {
  final String _url;
  URLIndexInfoStreams(this._url);
  @override
  Future<Null> readFully(IndexInfo to) async {
    final String s = await URLUtils._get(_url + '/.ii');
    if (s.length > 0) {
      to.updateFromMap(IndexInfo.getMap(s));
    }
  }
}

class URLLiveDocsStreams extends LiveDocsStreams {
  final String _url;
  URLLiveDocsStreams(this._url);
  @override
  Future<Null> readFully(IDocSet to) async {
    final String s = await URLUtils._get(_url + '/.liv');
    to.updateFromString(s);
  }
}

class URLIndexStreams extends IndexStreams {
  final List<String> _indexFields;
  final String _url;
  URLIndexStreams(this._indexFields, this._url);
  bool _readFully;

  @override
  Future<Null> readFully(Index to) async {
    _readFully = true;
    //for (String field in _indexFields) {
    await Future.forEach(_indexFields, (String field) {
      URLUtils._get(_url + '/$field.idx').then((String str) {
        final List<String> lines = str.split('\n');
        final Map<String, IDocSet> invertedIndex = Index.emptyTermDictionary();
        for (String line in lines) {
          final List<String> kv = line.split('=>');
          if (kv.length == 2) {
            invertedIndex[kv[0]] = IDocSet.newDocSetFromString(kv[1]);
          }
        }
        to[field] = invertedIndex;
      });
    }); //}
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

class URLDataStreams extends DataStreams {
  final List<String> _storedFields;
  final String _url;
  URLDataStreams(this._storedFields, this._url);
  bool _readFully;

  @override
  Future<Null> readFully(FieldData to) async {
    _readFully = true;
    //for (String field in _storedFields) {
    await Future.forEach(_storedFields, (String field) {
      URLUtils._get(_url + '/$field.data').then((String str) {
        final List<String> lines = str.split('\n');
        final Map<int, DocData> docValues = FieldData.emptyDocValues();
        for (String line in lines) {
          final List<String> kv = line.split('=>');
          if (kv.length == 2) {
            docValues[int.parse(kv[0])] = new DocData(kv[1].split('\$'));
          }
        }
        to[field] = docValues;
      });
    }); //}
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

class URLUtils {
  static Future<String> _get(String url) async {
    return HttpRequest.getString(url);
  }
}
