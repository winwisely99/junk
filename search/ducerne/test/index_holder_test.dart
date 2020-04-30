// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';

void main() {
  group('A group of holder', () {
    final Directory dir = new Directory('test-index');

    setUp(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    test('test RAM', () async {
      final RAMIndexHolderDirectory dir = new RAMIndexHolderDirectory();
      IndexHolder index = await DirectoryHolder.open(dir);

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
      await testAssert(searcher);
      searcher = await index.newRealTimeIndexSearcher();
      await testAssert(searcher);

      // re-init #1
      index = await DirectoryHolder.open(dir);
      searcher = await index.newIndexSearcher();
      await testAssert(searcher);
      searcher = await index.newRealTimeIndexSearcher();
      await testAssert(searcher);

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

      index = await DirectoryHolder.open(dir);

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
    });

    test('test FS', () async {
      IndexHolder index =
          await DirectoryHolder.open(new FSIndexHolderDirectory(dir));

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
      await testAssert(searcher);
      searcher = await index.newRealTimeIndexSearcher();
      await testAssert(searcher);

      // re-init #1
      index = await DirectoryHolder.open(new FSIndexHolderDirectory(dir));
      searcher = await index.newIndexSearcher();
      await testAssert(searcher);
      searcher = await index.newRealTimeIndexSearcher();
      await testAssert(searcher);

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

      index = await DirectoryHolder.open(new FSIndexHolderDirectory(dir));

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
    });

    test('test RAM forceMerge', () async {
      final IndexHolder index =
          await DirectoryHolder.open(new RAMIndexHolderDirectory());
      await forceMergeTestAssert(index);
    });

    test('test FS forceMerge', () async {
      final Directory dir = new Directory('test-index-merge');
      if (await dir.exists()) await dir.delete(recursive: true);
      final IndexHolder index =
          await DirectoryHolder.open(new FSIndexHolderDirectory(dir));
      await forceMergeTestAssert(index);
      if (await dir.exists()) await dir.delete(recursive: true);
    });
  });
}

Future<Null> testAssert(IndexSearcher searcher) async {
  TopDocs hits = await searcher.search(new BoolQuery().append("str", "x"), 10);
  expect(hits.totalHits, 2);
  expect((await searcher.doc(hits.scoreDocs[0].doc)).get("id"), "1");
  expect((await searcher.doc(hits.scoreDocs[1].doc)).get("id"), "3");
  hits = await searcher.search(new BoolQuery().append("str", "y"), 10);
  expect(hits.totalHits, 1);
  expect((await searcher.doc(hits.scoreDocs[0].doc)).get("id"), "2");
}

Future<Null> forceMergeTestAssert(IndexHolder index) async {
  await index.updateDocuments(
      <Document>[new Document().append("id", '1').append("str", "x")]);

  await index.updateDocuments(
      <Document>[new Document().append("id", '2').append("str", "x")]);

  await index.updateDocuments(
      <Document>[new Document().append("id", '3').append("str", "x")]);

  IndexSearcher searcher = await index.newIndexSearcher();
  expect(await searcher.count(new BoolQuery().append("str", "x")), 3);
  searcher = await index.newRealTimeIndexSearcher();
  expect(await searcher.count(new BoolQuery().append("str", "x")), 3);

  await index.updateDocuments(
      <Document>[new Document().append("id", '2').append("str", "y")]);

  searcher = await index.newIndexSearcher();
  expect(
      await searcher.count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
      3);
  expect(await searcher.count(new BoolQuery().append("str", "x")), 2);
  expect(await searcher.count(new BoolQuery().append("str", "y")), 1);
  searcher = await index.newRealTimeIndexSearcher();
  expect(
      await searcher.count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
      3);
  expect(await searcher.count(new BoolQuery().append("str", "x")), 2);
  expect(await searcher.count(new BoolQuery().append("str", "y")), 1);

  await index.forceMerge();
  searcher = await index.newIndexSearcher();
  expect(
      await searcher.count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
      3);
  expect(await searcher.count(new BoolQuery().append("str", "x")), 2);
  expect(await searcher.count(new BoolQuery().append("str", "y")), 1);
  searcher = await index.newRealTimeIndexSearcher();
  expect(
      await searcher.count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
      3);
  expect(await searcher.count(new BoolQuery().append("str", "x")), 2);
  expect(await searcher.count(new BoolQuery().append("str", "y")), 1);
}
