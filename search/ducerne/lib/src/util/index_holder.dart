// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import '../../src/index/document.dart';
import '../../src/index/index_reader.dart';
import '../../src/index/index_writer.dart';
import '../../src/search/index_searcher.dart';
import '../../src/search/query.dart';
import '../../src/store/index_directory.dart';
import '../../src/store/standard/composite_index_directory.dart';
import '../../src/store/standard/fs_index_directory.dart';
import '../../src/store/standard/ram_index_directory.dart';

/// An IndexHolder maintains multiple index segments.
///
/// It's best to use [DirectoryHolder.open(IndexHolderDirectory)] to obtain an IndexHolder.
class IndexHolder {
  final IndexHolderDirectory _holderDirectory;
  final RAMIndexHolderDirectory _realTimeHolderDirectory =
      new RAMIndexHolderDirectory();
  IndexHolder(this._holderDirectory);

  Future<Null> init() async {
    await _holderDirectory.init();
    await _realTimeHolderDirectory.init();
    _realTimeHolderDirectory.loadFrom(_holderDirectory);
  }

  Future<Null> updateDocuments(Iterable<Document> documents) async {
    final List<String> ids = <String>[];
    for (Document doc in documents) {
      ids.add(doc.get('id'));
    }
    final BoolQuery delQuery = new BoolQuery();
    for (String id in ids) {
      delQuery.addQuery(new TermQuery(new Term('id', id)));
    }
    await deleteDocuments(delQuery);

    final NamedIndexDirectory nDir = _holderDirectory.newIndexDirectory();
    final IndexDirectory directory = nDir.directory;
    final IndexWriter writer = new IndexWriter(directory);
    final IndexWriteModel model = writer.buildModel(documents);
    await writer.writeModel(model);
    _holderDirectory.register(nDir);

    if (_holderDirectory.directories.keys.length > 0) {
      final NamedIndexDirectory nDir =
          _realTimeHolderDirectory.newIndexDirectory();
      final IndexDirectory directory = nDir.directory;
      final IndexWriter writer = new IndexWriter(directory);
      await writer.writeModel(model);
      _realTimeHolderDirectory.register(nDir);
    }
  }

  Future<Null> deleteDocuments(BoolQuery query) async {
    if (_holderDirectory.directories.length > 10) {
      await forceMerge();
    }

    for (String name in _holderDirectory.directories.keys) {
      final IndexDirectory directory = _holderDirectory.directories[name];
      final IndexWriter writer = new IndexWriter(directory);
      await writer.delete(query);
    }

    if (_holderDirectory.directories.keys.length > 0) {
      for (String name in _realTimeHolderDirectory.directories.keys) {
        final IndexDirectory directory =
            _realTimeHolderDirectory.directories[name];
        final IndexWriter writer = new IndexWriter(directory);
        await writer.delete(query);
      }
    }
  }

  Future<Null> forceMerge() async {
    final NamedIndexDirectory nDir = _holderDirectory.newIndexDirectory();
    final IndexDirectory directory = nDir.directory;
    await IndexWriter.copyFrom(_newCompositeIndexDirectory(), directory);
    final IndexWriter writer = new IndexWriter(directory);
    await writer.expungeDeletes();
    await _holderDirectory.release();
    _holderDirectory.register(nDir);

    if (_holderDirectory.directories.keys.length > 0) {
      final NamedIndexDirectory nDir =
          _realTimeHolderDirectory.newIndexDirectory();
      final IndexDirectory directory = nDir.directory;
      await IndexWriter.copyFrom(
          _newRealTimeCompositeIndexDirectory(), directory);
      final IndexWriter writer = new IndexWriter(directory);
      await writer.expungeDeletes();
      await _realTimeHolderDirectory.release();
      _realTimeHolderDirectory.register(nDir);
    }
  }

  CompositeIndexDirectory _newCompositeIndexDirectory() {
    return new CompositeIndexDirectory(
        _holderDirectory.directories.values.toList());
  }

  CompositeIndexDirectory _newRealTimeCompositeIndexDirectory() {
    return new CompositeIndexDirectory(
        _realTimeHolderDirectory.directories.values.toList());
  }

  Future<IndexSearcher> newIndexSearcher() async {
    final IndexReader reader =
        await DirectoryReader.open(_newCompositeIndexDirectory());
    final IndexSearcher searcher = new IndexSearcher(reader);
    return searcher;
  }

  Future<IndexSearcher> newRealTimeIndexSearcher() async {
    final IndexReader reader =
        await DirectoryReader.open(_newRealTimeCompositeIndexDirectory());
    final IndexSearcher searcher = new IndexSearcher(reader);
    return searcher;
  }
}

abstract class IndexHolderDirectory {
  Map<String, IndexDirectory> directories = <String, IndexDirectory>{};
  Future<Null> init();
  void loadFrom(IndexHolderDirectory indexHolderDirectory) {
    for (String name in indexHolderDirectory.directories.keys) {
      directories[name] = indexHolderDirectory.directories[name];
    }
  }

  NamedIndexDirectory newIndexDirectory();
  Future<Null> release();
  void register(NamedIndexDirectory directoryKeyValue) {
    directories[directoryKeyValue.name] = directoryKeyValue.directory;
  }
}

class DirectoryHolder {
  static Future<IndexHolder> open(IndexHolderDirectory directoryHolder) async {
    final IndexHolder holder = new IndexHolder(directoryHolder);
    await holder.init();
    return holder;
  }
}

class NamedIndexDirectory {
  final String name;
  final IndexDirectory directory;
  NamedIndexDirectory(this.name, this.directory);
}

// [RAMIndexDirectory] based implementation.
class RAMIndexHolderDirectory extends IndexHolderDirectory {
  @override
  Future<Null> init() {
    return null;
  }

  @override
  NamedIndexDirectory newIndexDirectory() {
    final String name = (directories.length + 1)
        .toString()
        .padLeft(10, '0'); //.toRadixString(36);
    final IndexDirectory directory = new RAMIndexDirectory();
    return new NamedIndexDirectory(name, directory);
  }

  @override
  Future<Null> release() async {
    directories.clear();
  }
}

/// [FSIndexDirectory] based implementation.
class FSIndexHolderDirectory extends IndexHolderDirectory {
  final Directory _dir;
  FSIndexHolderDirectory(this._dir);

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
            new FSIndexDirectory(new Directory(path));
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
    final IndexDirectory directory = new FSIndexDirectory(new Directory(path));
    return new NamedIndexDirectory(name, directory);
  }

  @override
  Future<Null> release() async {
    for (String name in directories.keys) {
      final FSIndexDirectory directory = directories[name];
      final Directory target = directory.dir;
      await target.delete(recursive: true);
    }
    directories.clear();
  }
}
