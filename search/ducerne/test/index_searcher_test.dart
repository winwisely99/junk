// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/analysis.dart';
import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:test/test.dart';

void main() {
  group('A group of searcher', () {
    test('should have correct counts', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);
      final List<Document> docs = <Document>[];
      for (int i = 0; i < 10; i++) {
        final Document doc = new Document();
        doc.append("id", i.toString());
        doc.append("mv", <String>["m", "v"]);
        doc.append("filter", "filter");
        doc.append("price1", (i + 1).toString());
        doc.append("price2", ((i + 1) * 100).toString());
        docs.add(doc);
      }
      await writer.write(docs);

      final IndexReader reader = await DirectoryReader.open(indexDirectory);
      final IndexSearcher searcher = new IndexSearcher(reader);

      expect(await searcher.count(new BoolQuery(Op.and).append('id', '5')), 1);
      expect(
          await searcher
              .count(new BoolQuery(Op.and).addQuery(new MatchAllDocsQuery())),
          10);
      expect(
          await searcher.count(new BoolQuery(Op.and).append('id', 'dummy')), 0);
      expect(
          await searcher
              .count(new BoolQuery(Op.and).addQuery(new MatchNoDocsQuery())),
          0);
      expect(await searcher.count(new BoolQuery().append('id', '5')), 1);
      expect(
          await searcher
              .count(new BoolQuery().addQuery(new MatchAllDocsQuery())),
          10);
      expect(await searcher.count(new BoolQuery().append('id', 'dummy')), 0);
      expect(
          await searcher
              .count(new BoolQuery().addQuery(new MatchNoDocsQuery())),
          0);

      expect(await searcher.count(new BoolQuery(Op.or).append('mv', 'm')), 10);
      expect(await searcher.count(new BoolQuery(Op.or).append('mv', 'v')), 10);

      BoolQuery q = new BoolQuery()
          .addQuery(new MatchAllDocsQuery())
          .addFilter(new TermQuery(new Term('filter', 'filter')));
      expect(await searcher.count(q), 10);
      q = new BoolQuery()
          .addQuery(new MatchAllDocsQuery())
          .addFilter(new TermQuery(new Term('filter', 'dummy')));
      expect(await searcher.count(q), 0);
      q = new BoolQuery()
          .addQuery(new MatchAllDocsQuery())
          .addFilter(new TermQuery(new Term('filter', 'filter')))
          .addFilter(new TermQuery(new Term('filter', 'dummy')));
      expect(await searcher.count(q), 0);
      q = new BoolQuery()
          .addQuery(new MatchAllDocsQuery())
          .addFilter(new TermQuery(new Term('filter', 'filter')))
          .addFilter(new RangeQuery('price1', 3.00, 5.00));
      expect(await searcher.count(q), 3);
      q = new BoolQuery()
          .addQuery(new MatchAllDocsQuery())
          .addFilter(new TermQuery(new Term('filter', 'filter')))
          .addFilter(new RangeQuery('price1', 3.00, 5.00))
          .addFilter(new RangeQuery('price2', 400.00, 500.00));
      expect(await searcher.count(q), 2);
    });

    test('synonym filtering and not filtering', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);
      final Document doc1 = new Document()
        ..append("id", '01')
        ..append("text", "a");
      final Document doc2 = new Document()
        ..append("id", '02')
        ..append("text", "b");
      final Document doc3 = new Document()
        ..append("id", '03')
        ..append("text", "c");
      await writer.write(<Document>[doc1, doc2, doc3]);
      final IndexReader reader = await DirectoryReader.open(indexDirectory);
      final IndexSearcher searcher = new IndexSearcher(reader);
      BoolQuery q = new BoolQuery()
          .addQuery(new MatchAllDocsQuery())
          .addFilter(new TermsQuery(<Term>[new Term('text', 'a')]));
      expect(await searcher.count(q), 1);
      q = new BoolQuery().addQuery(new MatchAllDocsQuery()).addFilter(
          new TermsQuery(<Term>[new Term('text', 'a'), new Term('text', 'c')]));
      expect(await searcher.count(q), 2);

      q = new BoolQuery()
        ..addQuery(new MatchAllDocsQuery())
            .addFilter(new NotQuery(<Term>[new Term('text', 'a')]));
      expect(await searcher.count(q), 2);
      q = new BoolQuery().addQuery(new MatchAllDocsQuery()).addFilter(
          new NotQuery(<Term>[new Term('text', 'a'), new Term('text', 'c')]));
      expect(await searcher.count(q), 1);
      /*for (ScoreDoc doc in searcher.search(q,3,new MatchScoreSort()).scoreDocs) {
        print(searcher.doc(doc.doc).get("id"));
      }*/
    });

    test('test search by composite directory', () async {
      final Analyzer st = new StandardAnalyzer();

      final IndexDirectory first = new RAMIndexDirectory();
      IndexWriter writer = new IndexWriter(first);
      final Document d1 = new Document()
        ..append("id", "1")
        ..append("text", "1 aa 000", analyzer: st);
      final Document d2 = new Document()
        ..append("id", "2")
        ..append("text", "2 bb 000", analyzer: st);
      await writer.write(<Document>[d1, d2]);

      IndexReader reader = await DirectoryReader.open(first);
      IndexSearcher searcher = new IndexSearcher(reader);
      expect(await searcher.count(new BoolQuery().append("text", "aa")), 1);
      expect(await searcher.count(new BoolQuery().append("text", "000")), 2);
      expect(await searcher.count(new BoolQuery().append("text", "cc")), 0);

      final IndexDirectory second = new RAMIndexDirectory();
      writer = new IndexWriter(second);
      final Document d3 = new Document()
        ..append("id", "3")
        ..append("text", "1 cc", analyzer: st);
      final Document d4 = new Document()
        ..append("id", "4")
        ..append("text", "2 dd", analyzer: st);
      await writer.write(<Document>[d3, d4]);

      reader = await DirectoryReader.open(second);
      searcher = new IndexSearcher(reader);
      expect(await searcher.count(new BoolQuery().append("text", "aa")), 0);
      expect(await searcher.count(new BoolQuery().append("text", "cc")), 1);
      expect(await searcher.count(new BoolQuery().append("text", "dd")), 1);

      final IndexDirectory directory =
          new CompositeIndexDirectory(<IndexDirectory>[first, second]);
      reader = await DirectoryReader.open(directory);
      searcher = new IndexSearcher(reader);

      expect(await searcher.count(new BoolQuery().append("text", "aa")), 1);
      expect(await searcher.count(new BoolQuery().append("text", "bb")), 1);
      expect(await searcher.count(new BoolQuery().append("text", "cc")), 1);
      expect(await searcher.count(new BoolQuery().append("text", "dd")), 1);
      expect(await searcher.count(new BoolQuery().append("text", "1")), 2);
      expect(await searcher.count(new BoolQuery().append("text", "2")), 2);

      TopDocs hits =
          await searcher.search(new BoolQuery().append("id", "1"), 10);
      expect(hits.totalHits, 1);
      expect(
          (await searcher.doc(hits.scoreDocs[0].doc)).get("text"), "1 aa 000");

      hits = await searcher.search(new BoolQuery().append("id", "2"), 10);
      expect(hits.totalHits, 1);
      expect(
          (await searcher.doc(hits.scoreDocs[0].doc)).get("text"), "2 bb 000");

      hits = await searcher.search(new BoolQuery().append("id", "3"), 10);
      expect(hits.totalHits, 1);
      expect((await searcher.doc(hits.scoreDocs[0].doc)).get("text"), "1 cc");

      hits = await searcher.search(new BoolQuery().append("id", "4"), 10);
      expect(hits.totalHits, 1);
      expect((await searcher.doc(hits.scoreDocs[0].doc)).get("text"), "2 dd");
    });

    test('test tfidf sort', () async {
      final Analyzer ws = new WhitespaceAnalyzer();

      final IndexDirectory directory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(directory);
      final Document d1 = new Document()
        ..append("id", "1")
        ..append("text", "aa xx", analyzer: ws);
      final Document d2 = new Document()
        ..append("id", "2")
        ..append("text", "aa xx", analyzer: ws);
      final Document d3 = new Document()
        ..append("id", "3")
        ..append("text", "yy bb", analyzer: ws);
      final Document d4 = new Document()
        ..append("id", "4")
        ..append("text", "aa yy", analyzer: ws);
      await writer.write(<Document>[d1, d2, d3, d4]);

      final IndexReader reader = await DirectoryReader.open(directory);
      final IndexSearcher searcher = new IndexSearcher(reader);
      final ScoreSort ss = new TFIDFScoreSort();
      TopDocs hits = await searcher.search(
          new BoolQuery(Op.or).append("text", "aa bb", analyzer: ws), 10,
          scoreSort: ss);
      expect((await searcher.doc(hits.scoreDocs[0].doc)).get("id"), "3");
      expect((await searcher.doc(hits.scoreDocs[1].doc)).get("id"), "1");
      expect((await searcher.doc(hits.scoreDocs[2].doc)).get("id"), "2");
      expect((await searcher.doc(hits.scoreDocs[3].doc)).get("id"), "4");

      hits = await searcher.search(
          new BoolQuery(Op.or)
              .append("text", "aa bb", analyzer: ws)
              .append("id", "2", boost: 10.0),
          10,
          scoreSort: ss);
      expect((await searcher.doc(hits.scoreDocs[0].doc)).get("id"), "2");
      expect((await searcher.doc(hits.scoreDocs[1].doc)).get("id"), "3");
      expect((await searcher.doc(hits.scoreDocs[2].doc)).get("id"), "1");
      expect((await searcher.doc(hits.scoreDocs[3].doc)).get("id"), "4");
    });
  });
}
