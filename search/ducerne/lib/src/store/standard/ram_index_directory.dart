// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../../src/index/index_reader.dart';
import '../../../src/store/index_directory.dart';

/// A memory-resident [IndexDirectory] implementation.
class RAMIndexDirectory implements IndexDirectory {
  IndexInfo _info = IndexInfo.empty();
  IDocSet _liveDocs = IDocSet.empty();
  final Index _index = Index.empty();
  final FieldData _data = FieldData.empty();

  @override
  Future<Null> initOutput() async {}

  @override
  Future<Null> outputIndexInfo(IndexInfo info) async {
    _info = info;
  }

  @override
  Future<Null> outputLiveDocs(IDocSet docIds) async {
    _liveDocs = IDocSet.newDocSetFromDocSet(docIds);
  }

  @override
  Future<Null> outputIndex(String name, Map<String, IDocSet> index) async {
    _index[name] = index;
  }

  @override
  Future<Null> outputData(String name, Map<int, DocData> data) async {
    _data[name] = data;
  }

  @override
  void initInput() {}

  @override
  IndexInfoSource inputIndexInfo() =>
      new IndexInfoSource(new RAMIndexInfoStreams(_info));

  @override
  LiveDocsSource inputLiveDocs() =>
      new LiveDocsSource(new RAMLiveDocsStreams(_liveDocs));

  @override
  IndexSource inputIndex() => new IndexSource(new RAMIndexStreams(_index));

  @override
  DataSource inputData() => new DataSource(new RAMDataStreams(_data));
}

class RAMIndexInfoStreams extends IndexInfoStreams {
  final IndexInfo _info;
  RAMIndexInfoStreams(this._info);
  @override
  Future<Null> readFully(IndexInfo to) async {
    to.updateFromMap(_info.toMap());
  }
}

class RAMLiveDocsStreams extends LiveDocsStreams {
  final IDocSet _liveDocs;
  RAMLiveDocsStreams(this._liveDocs);
  @override
  Future<Null> readFully(IDocSet to) async {
    to.updateFromDocSet(_liveDocs);
  }
}

class RAMIndexStreams extends IndexStreams {
  final Index _index;
  RAMIndexStreams(this._index);
  bool _readFully = false;
  @override
  Future<Null> readFully(Index to) async {
    for (String field in _index.keys) {
      to[field] = _index[field];
    }
    _readFully = true;
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

class RAMDataStreams extends DataStreams {
  final FieldData _data;
  RAMDataStreams(this._data);
  bool _readFully = false;
  @override
  Future<Null> readFully(FieldData to) async {
    for (String field in _data.keys) {
      to[field] = _data[field];
    }
    _readFully = true;
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
