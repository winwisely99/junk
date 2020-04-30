// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../src/index/index_reader.dart';

/// All i/o is through this API.
abstract class IndexDirectory {
  Future<Null> initOutput();
  Future<Null> outputIndexInfo(IndexInfo info);
  Future<Null> outputLiveDocs(IDocSet docIds);
  Future<Null> outputIndex(String name, Map<String, IDocSet> index);
  Future<Null> outputData(String name, Map<int, DocData> data);
  void initInput();
  IndexInfoSource inputIndexInfo();
  LiveDocsSource inputLiveDocs();
  IndexSource inputIndex();
  DataSource inputData();
}

class IndexInfoSource {
  final IndexInfoStreams _streams;
  IndexInfoSource(this._streams);
  Future<Null> read(IndexInfo to) async {
    await _streams.readFully(to);
  }
}

class LiveDocsSource {
  final LiveDocsStreams _streams;
  LiveDocsSource(this._streams);
  Future<Null> read(IDocSet to) async {
    await _streams.readFully(to);
  }
}

class IndexSource {
  final IndexStreams _streams;
  IndexSource(this._streams);
  Future<Null> read(Index to) async {
    await _streams.readFully(to);
  }

  Future<Null> terms(String field, Index to) async {
    await _streams.readTerms(field, to);
  }

  Future<Null> postings(String field, String term, Index to) async {
    await _streams.readPostings(field, term, to);
  }
}

class DataSource {
  DataStreams _streams;
  DataSource(this._streams);
  Future<Null> read(FieldData to) async {
    await _streams.readFully(to);
  }

  Future<Null> fields(FieldData to) async {
    await _streams.readFields(to);
  }

  Future<Null> values(String field, int docId, FieldData to) async {
    await _streams.readValues(field, docId, to);
  }
}

// ignore: one_member_abstracts
abstract class IndexInfoStreams {
  Future<Null> readFully(IndexInfo to);
}

// ignore: one_member_abstracts
abstract class LiveDocsStreams {
  Future<Null> readFully(IDocSet to);
}

abstract class IndexStreams {
  Future<Null> readFully(Index to);
  Future<Null> readTerms(String field, Index to);
  Future<Null> readPostings(String field, String term, Index to);
}

abstract class DataStreams {
  Future<Null> readFully(FieldData to);
  Future<Null> readFields(FieldData to);
  Future<Null> readValues(String field, int docId, FieldData to);
}
