// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:firebase/firebase.dart' as firebase;

import '../../../src/index/index_reader.dart';
import '../../../src/store/index_directory.dart';

class FirebaseIndexDirectory implements IndexDirectory {
  final FirebaseIndexStreams _indexStreams;
  final FirebaseDataStreams _dataStreams;
  FirebaseIndexDirectory(this._indexStreams, this._dataStreams);

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
  IndexInfoSource inputIndexInfo() {
    return new IndexInfoSource(new FirebaseIndexInfoStreams());
  }

  @override
  LiveDocsSource inputLiveDocs() {
    return new LiveDocsSource(new FirebaseLiveDocsStreams());
  }

  @override
  IndexSource inputIndex() {
    return new IndexSource(_indexStreams);
  }

  @override
  DataSource inputData() {
    return new DataSource(_dataStreams);
  }
}

class FirebaseIndexInfoStreams extends IndexInfoStreams {
  FirebaseIndexInfoStreams();
  @override
  Future<Null> readFully(IndexInfo to) async {
    // ignore: always_specify_types
    final ref = firebase.database().ref("info");
    // ignore: always_specify_types
    final event = await ref.once("value");
    final String s = event.snapshot.val();
    if (s.length > 0) {
      to.updateFromMap(IndexInfo.getMap(s));
    }
  }
}

class FirebaseLiveDocsStreams extends LiveDocsStreams {
  FirebaseLiveDocsStreams();
  @override
  Future<Null> readFully(IDocSet to) async {
    // ignore: always_specify_types
    final ref = firebase.database().ref("liv");
    // ignore: always_specify_types
    final event = await ref.once("value");
    final String s = event.snapshot.val();
    if (s.length > 0) {
      //to.updateFromString(s); // TODO
      final Set<int> docIds = SetDocSet.getList(s).toSet();
      to.updateFromSet(docIds, docIds.length);
    }
  }
}

class FirebaseIndexStreams extends IndexStreams {
  bool _readFully;
  bool loaded = false;

  final FirebaseIndexInfoStreams _firebaseIndexInfoStreams;
  FirebaseIndexStreams(this._firebaseIndexInfoStreams);

  @override
  Future<Null> readFully(Index to) async {
    _readFully = true;

    final IndexInfo info = IndexInfo.empty();
    await _firebaseIndexInfoStreams.readFully(info);
    final int maxDoc = info.getMaxDoc();

    final List<String> fields = await FirebaseUtils.getFields("idx");
    for (String field in fields) {
      final Map<String, IDocSet> termDict =
          await _getTermDictionary("idx/" + field, maxDoc);
      to[field] = termDict;
    }

    loaded = true;
  }

  Future<Map<String, IDocSet>> _getTermDictionary(
      String path, int maxDoc) async {
    final Map<String, IDocSet> termDict = Index.emptyTermDictionary();
    // ignore: always_specify_types
    final query = firebase.database().ref(path).orderByKey();
    // ignore: always_specify_types
    final event = await query.once("value");
    // ignore: always_specify_types
    event.snapshot.forEach((e) {
      final String key = e.val()["term"];
      final String values = e.val()["postings"];
      //termDict[key] = IDocSet.newDocSetFromString(values);
      final Set<int> docIds = SetDocSet.getList(values).toSet();
      termDict[key] = IDocSet.newDocSetFromSet(docIds, maxDoc);
    });
    return termDict;
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

class FirebaseDataStreams extends DataStreams {
  bool _readFully;
  bool loaded = false;

  @override
  Future<Null> readFully(FieldData to) async {
    _readFully = true;
    final List<String> fields = await FirebaseUtils.getFields("data");
    for (String field in fields) {
      final Map<int, DocData> docValues = await _getDocValues("data/" + field);
      to[field] = docValues;
    }
    loaded = true;
  }

  Future<Map<int, DocData>> _getDocValues(String path) async {
    final Map<int, DocData> docValues = FieldData.emptyDocValues();
    // ignore: always_specify_types
    final query = firebase.database().ref(path).orderByKey();
    // ignore: always_specify_types
    final event = await query.once("value");
    // ignore: always_specify_types
    event.snapshot.forEach((e) {
      final int key = int.parse(e.key);
      final List<String> values = e.val().split('\$');
      docValues[key] = new DocData(values);
    });
    return docValues;
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

class FirebaseUtils {
  static Future<List<String>> getFields(String extension) async {
    final List<String> fields = <String>[];
    // ignore: always_specify_types
    final query = firebase.database().ref(extension).orderByKey();
    // ignore: always_specify_types
    final event = await query.once("value");
    // ignore: always_specify_types
    event.snapshot.forEach((e) => fields.add(e.key));
    return fields;
  }
}
