// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:test/test.dart';

void main() {
  group('A group of writer', () {
    final Directory dir1 = new Directory('test-dir-writer1');
    IndexDirectory d1;
    final Directory dir2 = new Directory('test-dir-writer2');
    IndexDirectory d2;
    final Directory dir3 = new Directory('test-dir-writer3');
    IndexDirectory d3;

    setUp(() async {
      if (await dir1.exists()) await dir1.delete(recursive: true);
      d1 = new FSIndexDirectory(dir1);
      if (await dir2.exists()) await dir2.delete(recursive: true);
      d2 = new FSIndexDirectory(dir2);
      if (await dir3.exists()) await dir3.delete(recursive: true);
      d3 = new FSIndexDirectory(dir3);
    });

    tearDown(() async {
      if (await dir1.exists()) await dir1.delete(recursive: true);
      if (await dir2.exists()) await dir2.delete(recursive: true);
      if (await dir3.exists()) await dir3.delete(recursive: true);
    });

    test('test rewrite', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);
      List<Document> docs = <Document>[];
      for (int i = 0; i < 10; i++) {
        final Document doc = new Document();
        doc.append("id", i.toString());
        docs.add(doc);
      }
      await writer.write(docs);

      expect(await (await DirectoryReader.open(indexDirectory)).maxDoc(), 10);

      docs = <Document>[];
      for (int i = 0; i < 3; i++) {
        final Document doc = new Document();
        doc.append("id", i.toString());
        docs.add(doc);
      }
      await writer.write(docs);

      expect(await (await DirectoryReader.open(indexDirectory)).maxDoc(), 3);
    });

    test('test index and search get()', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);
      final Document doc = new Document();
      doc.append("id", '1');
      doc.append("text1", 'text1');
      doc.append("text2", <String>['text2-1', 'text2-2']);
      doc.append("text3", 'text3', stored: false);
      doc.append("text4", <String>['text4-1', 'text4-2'], stored: false);
      await writer.write(<Document>[doc]);

      final IndexReader reader = await DirectoryReader.open(indexDirectory);
      final IndexSearcher searcher = new IndexSearcher(reader);
      final TopDocs docs = await searcher.search(
          new BoolQuery().append("id", '1'), 10,
          scoreSort: ScoreSort.indexed());
      expect(docs.totalHits, 1);
      final ScoreDoc scoreDoc = docs.scoreDocs[0];
      final Document d = await searcher.doc(scoreDoc.doc);
      expect(d.get("id"), '1');
      expect(d.get("text1"), 'text1');
      expect(d.getValues("text2"), <String>['text2-1', 'text2-2']);
      expect(d.get("text3"), isNull);
      expect(d.getValues("text4"), isNull);
    });

    test('test delete simple', () async {
      final IndexWriter writer = new IndexWriter(d1);
      await writer.write(<Document>[
        new Document().append("id", '1'),
        new Document().append("id", '2'),
        new Document().append("id", '3')
      ]);

      IndexReader reader = await DirectoryReader.open(d1);
      IndexSearcher searcher = new IndexSearcher(reader);
      expect(
          await searcher
              .count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
          3);

      await writer.delete(new BoolQuery().append("id", "2"));

      reader = await DirectoryReader.open(d1);
      searcher = new IndexSearcher(reader);
      expect(
          await searcher
              .count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
          2);
    });

    test('test copyFrom', () async {
      IndexWriter writer = new IndexWriter(d1);
      await writer.write(<Document>[
        new Document()..append("id", 'id-a'),
        new Document()..append("id", 'id-b')
      ]);

      writer = new IndexWriter(d2);
      await writer.write(<Document>[
        new Document().append("id", 'id-c'),
        new Document().append("id", 'id-d'),
        new Document().append("id", 'id-e')
      ]);

      await writer.delete(new BoolQuery().append("id", 'id-d'));

      final CompositeIndexDirectory compositeDir =
          new CompositeIndexDirectory(<IndexDirectory>[d1, d2]);
      await IndexWriter.copyFrom(compositeDir, d3);

      final IndexReader reader = await DirectoryReader.open(d3);
      final IndexSearcher searcher = new IndexSearcher(reader);
      expect(
          await searcher
              .count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
          4);
    });

    test('test update a document', () async {
      final IndexDirectory segment1 = d1;
      IndexWriter writer = new IndexWriter(segment1);
      await writer.write(<Document>[
        new Document().append("id", '1').append("str", "x"),
        new Document().append("id", '2').append("str", "x"),
        new Document().append("id", '3').append("str", "x")
      ]);

      IndexReader reader = await DirectoryReader.open(d1);
      IndexSearcher searcher = new IndexSearcher(reader);
      expect(await searcher.count(new BoolQuery().append("str", "x")), 3);

      //need to execute searches against all segments. see index_holder_test.
      await writer.delete(new BoolQuery().append("id", "2"));
      final IndexDirectory segment2 = d2;
      writer = new IndexWriter(segment2);
      await writer.write(
          <Document>[new Document().append("id", '2').append("str", "y")]);

      final CompositeIndexDirectory compositeDir =
          new CompositeIndexDirectory(<IndexDirectory>[d1, d2]);
      reader = await DirectoryReader.open(compositeDir);
      searcher = new IndexSearcher(reader);
      TopDocs hits =
          await searcher.search(new BoolQuery().append("str", "x"), 10);
      expect(hits.totalHits, 2);
      expect((await searcher.doc(hits.scoreDocs[0].doc)).get("id"), "1");
      expect((await searcher.doc(hits.scoreDocs[1].doc)).get("id"), "3");
      hits = await searcher.search(new BoolQuery().append("str", "y"), 10);
      expect(hits.totalHits, 1);
      expect((await searcher.doc(hits.scoreDocs[0].doc)).get("id"), "2");
    });

    test('test expungeDeletes simple', () async {
      final IndexDirectory segment1 = d1;
      final IndexWriter writer = new IndexWriter(segment1);
      await writer.write(<Document>[
        new Document().append("id", '1').append("str", "x"),
        new Document().append("id", '2').append("str", "y"),
        new Document().append("id", '3').append("str", "z")
      ]);

      await writer.delete(new BoolQuery().append("id", "2"));

      IndexReader reader = await DirectoryReader.open(d1);
      expect((await reader.postings("id", "1")).docCount(), 1);
      expect((await reader.postings("id", "2")).docCount(), 1);

      await writer.expungeDeletes();

      reader = await DirectoryReader.open(d1);
      expect((await reader.postings("id", "1")).docCount(), 1);
      expect((await reader.postings("id", "2")).docCount(), 0);
    });
  });
}
