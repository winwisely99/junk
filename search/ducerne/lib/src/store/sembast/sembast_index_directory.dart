// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../../../src/index/index_reader.dart';
import '../../../src/store/index_directory.dart';
import '../../../src/util/index_holder.dart';

class SembastIndexDirectory implements IndexDirectory {
  final DatabaseFactory _dbFactory = new IoDatabaseFactory();
  final List<String> _indexedFields;
  final List<String> _storedFields;
  final String _dbPath;
  SembastIndexDirectory(this._dbPath, this._indexedFields, this._storedFields);
  String get dbPath => _dbPath;

  @override
  Future<Null> initOutput() async {
    await _dbFactory.deleteDatabase('$_dbPath/.ii');
    await _dbFactory.deleteDatabase('$_dbPath/.liv');
    for (String field in _indexedFields) {
      await _dbFactory.deleteDatabase('$_dbPath/$field.idx');
    }
    for (String field in _storedFields) {
      await _dbFactory.deleteDatabase('$_dbPath/$field.data');
    }
  }

  @override
  Future<Null> outputIndexInfo(IndexInfo info) async {
    final Database db = await _dbFactory.openDatabase('$_dbPath/.ii');
    await db.put(info.toString(), '__INDEXINFO__');
    db.close();
  }

  @override
  Future<Null> outputLiveDocs(IDocSet docIds) async {
    await _dbFactory.deleteDatabase('$_dbPath/.liv');
    final Database db = await _dbFactory.openDatabase('$_dbPath/.liv');
    await db.put(docIds.toString(), '__LIVEDOCS__');
    db.close();
  }

  @override
  Future<Null> outputIndex(String name, Map<String, IDocSet> index) async {
    final Database db = await _dbFactory.openDatabase('$_dbPath/$name.idx');
    final List<String> terms = <String>[];
    for (String term in index.keys) {
      terms.add(term);
      final String postings = index[term].toString();
      await db.put(postings, term);
    }
    await db.put(terms.join('\$'), '__TERMS__');
    db.close();
  }

  @override
  Future<Null> outputData(String name, Map<int, DocData> data) async {
    final Database db = await _dbFactory.openDatabase('$_dbPath/$name.data');
    final List<int> docIds = <int>[];
    for (int docId in data.keys) {
      docIds.add(docId);
      final List<String> datum = data[docId].toList();
      await db.put(datum.join("\$"), docId);
    }
    await db.put(docIds.join('\$'), '__DOCIDS__');
    db.close();
  }

  @override
  void initInput() {}

  @override
  IndexInfoSource inputIndexInfo() =>
      new IndexInfoSource(new SembastIndexInfoStreams(_dbPath, _dbFactory));

  @override
  LiveDocsSource inputLiveDocs() {
    return new LiveDocsSource(new SembastLiveDocsStreams(_dbPath, _dbFactory));
  }

  @override
  IndexSource inputIndex() {
    _indexStreams =
        new SembastIndexStreams(_indexedFields, _dbPath, _dbFactory);
    return new IndexSource(_indexStreams);
  }

  @override
  DataSource inputData() {
    _dataStreams = new SembastDataStreams(_storedFields, _dbPath, _dbFactory);
    return new DataSource(_dataStreams);
  }

  SembastIndexStreams _indexStreams;
  SembastDataStreams _dataStreams;
  bool loaded() => _indexStreams.loaded && _dataStreams.loaded;
}

class SembastIndexInfoStreams extends IndexInfoStreams {
  final DatabaseFactory _dbFactory;
  final String _dbPath;
  SembastIndexInfoStreams(this._dbPath, this._dbFactory);
  @override
  Future<Null> readFully(IndexInfo to) async {
    final Database db = await _dbFactory.openDatabase('$_dbPath/.ii');
    final String s = await db.get('__INDEXINFO__');
    if (s.length > 0) {
      to.updateFromMap(IndexInfo.getMap(s));
    }
  }
}

class SembastLiveDocsStreams extends LiveDocsStreams {
  final DatabaseFactory _dbFactory;
  final String _dbPath;
  SembastLiveDocsStreams(this._dbPath, this._dbFactory);
  @override
  Future<Null> readFully(IDocSet to) async {
    final Database db = await _dbFactory.openDatabase('$_dbPath/.liv');
    final String s = await db.get('__LIVEDOCS__');
    if (s.length > 0) {
      to.updateFromString(s);
    }
  }
}

class SembastIndexStreams extends IndexStreams {
  final List<String> _indexedFields;
  final String _dbPath;
  final DatabaseFactory _dbFactory;
  SembastIndexStreams(this._indexedFields, this._dbPath, this._dbFactory);
  bool _readFully = false;
  bool loaded = false;

  @override
  Future<Null> readFully(Index to) async {
    _readFully = true;
    for (String field in _indexedFields) {
      final Database db = await _dbFactory.openDatabase('$_dbPath/$field.idx');
      final String s = await db.get('__TERMS__');
      final List<String> terms = s.split('\$').toList();
      final Map<String, IDocSet> termDict = Index.emptyTermDictionary();
      for (String term in terms) {
        termDict[term] = IDocSet.newDocSetFromString(await db.get(term));
      }
      to[field] = termDict;
    }
    loaded = true;
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

class SembastDataStreams extends DataStreams {
  final List<String> _storedFields;
  final String _dbPath;
  final DatabaseFactory _dbFactory;
  SembastDataStreams(this._storedFields, this._dbPath, this._dbFactory);
  bool _readFully = false;
  bool loaded = false;

  @override
  Future<Null> readFully(FieldData to) async {
    _readFully = true;
    for (String field in _storedFields) {
      final Database db = await _dbFactory.openDatabase('$_dbPath/$field.data');
      final String s = await db.get('__DOCIDS__');
      final List<int> docIds =
          s.split('\$').map((String s) => int.parse(s)).toList();
      final Map<int, DocData> docValues = FieldData.emptyDocValues();
      for (int docId in docIds) {
        final String ss = await db.get(docId);
        final List<String> values = ss.split('\$').toList();
        docValues[docId] = new DocData(values);
      }
      to[field] = docValues;
    }
    loaded = true;
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

/// [SembastIndexDirectory] based implementation.
class SembastIndexHolderDirectory extends IndexHolderDirectory {
  final Directory _dir;
  final List<String> _indexedFields;
  final List<String> _storedFields;
  SembastIndexHolderDirectory(
      this._dir, this._indexedFields, this._storedFields);

  @override
  Future<Null> init() async {
    if (await _dir.exists()) {
      final List<String> paths = await _dir
          .list(recursive: false, followLinks: false)
          .map((FileSystemEntity e) => e.path)
          .toList();
      paths.sort();
      for (String path in paths) {
        final String name = path.split('/').last;
        final IndexDirectory directory =
            new SembastIndexDirectory(path, _indexedFields, _storedFields);
        directories[name] = directory;
      }
    }
    return null;
  }

  @override
  NamedIndexDirectory newIndexDirectory() {
    int number;
    if (directories.length == 0) {
      number = 0;
    } else {
      number = int.parse(directories.keys.last);
    }
    final String name = (number + 1).toString().padLeft(10, '0');
    final String path = '${_dir.path}/$name';
    final IndexDirectory directory =
        new SembastIndexDirectory(path, _indexedFields, _storedFields);
    return new NamedIndexDirectory(name, directory);
  }

  @override
  Future<Null> release() async {
    for (String name in directories.keys) {
      final SembastIndexDirectory directory = directories[name];
      final Directory target = new Directory(directory.dbPath);
      await target.delete(recursive: true);
    }
    directories.clear();
  }
}
