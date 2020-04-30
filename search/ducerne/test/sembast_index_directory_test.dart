// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';
import 'index_holder_test.dart' as index_holder_test;

void main() {
  group('A group of directory', () {
    SembastIndexDirectory directory;
    final Directory dir = new Directory('test-dir');

    setUp(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
      if (!await dir.exists()) await dir.create(recursive: true);
      directory =
          new SembastIndexDirectory("test-dir", <String>["id"], <String>["id"]);
    });

    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    test('test 001', () async {
      final IndexWriter writer = new IndexWriter(directory);
      final List<Document> docs = <Document>[];
      for (int i = 0; i < 10; i++) {
        final Document doc = new Document();
        doc.append("id", i.toString());
        docs.add(doc);
      }
      await writer.write(docs);

      final IndexReader reader = await DirectoryReader.open(directory);
      final IndexSearcher searcher = new IndexSearcher(reader);

      expect(await searcher.count(new BoolQuery().append('id', '5')), 1);
      expect(
          await searcher
              .count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
          10);
    }, skip: true);
  });

  group('A group of holder', () {
    final Directory dir = new Directory('test-index');

    setUp(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    test('test Sembast', () async {
      IndexHolder index = await DirectoryHolder.open(
          new SembastIndexHolderDirectory(
              dir, <String>["id", "str"], <String>["id", "str"]));

      await index.updateDocuments(<Document>[
        new Document().append("id", '1').append("str", "x"),
        new Document().append("id", '2').append("str", "x"),
        new Document().append("id", '3').append("str", "x")
      ]);

      IndexSearcher searcher = await index.newIndexSearcher();
      expect(await searcher.count(new BoolQuery().append("str", "x")), 3);
      searcher = await index.newRealTimeIndexSearcher();
      expect(await searcher.count(new BoolQuery().append("str", "x")), 3);

      await index.updateDocuments(
          <Document>[new Document().append("id", '2').append("str", "y")]);

      searcher = await index.newIndexSearcher();
      await index_holder_test.testAssert(searcher);
      searcher = await index.newRealTimeIndexSearcher();
      await index_holder_test.testAssert(searcher);

      // re-init #1
      index = await DirectoryHolder.open(new SembastIndexHolderDirectory(
          dir, <String>["id", "str"], <String>["id", "str"]));
      searcher = await index.newIndexSearcher();
      await index_holder_test.testAssert(searcher);
      searcher = await index.newRealTimeIndexSearcher();
      await index_holder_test.testAssert(searcher);

      // re-init #2
      await index.updateDocuments(
          <Document>[new Document().append("id", '11').append("str", "a")]);
      searcher = await index.newRealTimeIndexSearcher();
      expect(await searcher.count(new BoolQuery().append("str", "a")), 1);

      await index.updateDocuments(
          <Document>[new Document().append("id", '12').append("str", "b")]);
      searcher = await index.newRealTimeIndexSearcher();
      expect(
          await searcher
              .count(new BoolQuery().append("str", "a").append("str", "b")),
          2);

      index = await DirectoryHolder.open(new SembastIndexHolderDirectory(
          dir, <String>["id", "str"], <String>["id", "str"]));

      await index.updateDocuments(
          <Document>[new Document().append("id", '13').append("str", "c")]);

      searcher = await index.newIndexSearcher();
      expect(
          await searcher.count(new BoolQuery()
              .append("str", "a")
              .append("str", "b")
              .append("str", "c")),
          3);
      searcher = await index.newRealTimeIndexSearcher();
      expect(
          await searcher.count(new BoolQuery()
              .append("str", "a")
              .append("str", "b")
              .append("str", "c")),
          3);
    }, skip: true);

    test('test Sembast forceMerge', () async {
      final IndexHolder index = await DirectoryHolder.open(
          new SembastIndexHolderDirectory(
              dir, <String>["id", "str"], <String>["id", "str"]));
      await index_holder_test.forceMergeTestAssert(index);
    }, skip: true);
  });
}
