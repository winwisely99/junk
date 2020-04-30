// Copyright (c) 2017, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:ducene/search.dart';
import 'package:ducene/index.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';

void main() {
  group('A group of recs builder', () {
    test('test cosineSim', () {
      //JML and SR
      expect(
          RecsBuilder.cosineSim(<double>[3.0, 1.5, 0.0, 3.0, 2.0, 0.0],
              <double>[4.0, 5.0, 5.0, 3.5, 3.0, 4.0]),
          0.7194516271218333);
      //SOP and SR
      expect(
          RecsBuilder.cosineSim(<double>[3.5, 3.5, 4.0, 3.5, 4.0, 4.5],
              <double>[4.0, 5.0, 5.0, 3.5, 3.0, 4.0]),
          0.9779828587551703);
    });

    test('test basic', () async {
      final RecsBuilderConfig config = new RecsBuilderConfig();
      config.fieldNameForUser = "user";
      config.fieldNameForItem = "docId";
      config.fieldNameForRating = "count";

      // add events
      final IndexHolder events =
          await DirectoryHolder.open(new RAMIndexHolderDirectory());
      await RecsBuilder.addEvents(events, getEventsTwo());

      // transform events into user-item matrix
      final IndexHolder userItem =
          await DirectoryHolder.open(new RAMIndexHolderDirectory());
      await RecsBuilder.transformEvents(config, events, userItem);

      // build item similarity matrix
      final IndexHolder itemSimilarity =
          await DirectoryHolder.open(new RAMIndexHolderDirectory());
      await RecsBuilder.buildItemSimilarity(config, userItem, itemSimilarity);

      // predict ratings
      final IndexHolder predictRatings =
          await DirectoryHolder.open(new RAMIndexHolderDirectory());
      await RecsBuilder.predictRatings(
          config, userItem, itemSimilarity, predictRatings);

      //await printDocs(events);
      //await printDocs(userItem);
      //await printDocs(itemSimilarity);
      //await printDocs(predictRatings);
    });
  });
}

Future<Null> printDocs(IndexHolder collection) async {
  final IndexSearcher searcher = await collection.newRealTimeIndexSearcher();
  final TopDocs docs = await searcher.search(
      new BoolQuery().addQuery(new MatchAllDocsQuery()), 1000);
  for (ScoreDoc scoreDocs in docs.scoreDocs) {
    final Document document = await searcher.doc(scoreDocs.doc);
    for (Field field in document.fields) {
      final String fieldAndValue = field.name + ":" + document.get(field.name);
      print(fieldAndValue);
    }
  }
}

List<Document> getEventsOne() {
  final List<Document> docs = <Document>[];

  Document doc = new Document()
      .append("id", "1")
      .append("query", "a")
      .append("docId", "1")
      .append("user", "a")
      .append("count", "1")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "2")
      .append("query", "a")
      .append("docId", "1")
      .append("user", "a")
      .append("count", "1")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "3")
      .append("query", "b")
      .append("docId", "1")
      .append("user", "b")
      .append("count", "1")
      .append("timestamp", "1");
  docs.add(doc);

  return docs;
}

List<Document> getEventsTwo() {
  final List<Document> docs = <Document>[];

  Document doc = new Document()
      .append("id", "C1")
      .append("query", "claudia")
      .append("docId", "JML")
      .append("user", "claudia")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "C2")
      .append("query", "claudia")
      .append("docId", "LIW")
      .append("user", "claudia")
      .append("count", "3.5")
      .append("timestamp", "1");
  //docs.add(doc);

  doc = new Document()
      .append("id", "C3")
      .append("query", "claudia")
      .append("docId", "SOP")
      .append("user", "claudia")
      .append("count", "3.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "C4")
      .append("query", "claudia")
      .append("docId", "SR")
      .append("user", "claudia")
      .append("count", "4")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "C5")
      .append("query", "claudia")
      .append("docId", "NL")
      .append("user", "claudia")
      .append("count", "4.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "C6")
      .append("query", "claudia")
      .append("docId", "YMD")
      .append("user", "claudia")
      .append("count", "2.5")
      .append("timestamp", "1");
  docs.add(doc);

  //
  doc = new Document()
      .append("id", "G1")
      .append("query", "gene")
      .append("docId", "JML")
      .append("user", "gene")
      .append("count", "1.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "G2")
      .append("query", "gene")
      .append("docId", "LIW")
      .append("user", "gene")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "G3")
      .append("query", "gene")
      .append("docId", "SOP")
      .append("user", "gene")
      .append("count", "3.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "G4")
      .append("query", "gene")
      .append("docId", "SR")
      .append("user", "gene")
      .append("count", "5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "G5")
      .append("query", "gene")
      .append("docId", "NL")
      .append("user", "gene")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "G6")
      .append("query", "gene")
      .append("docId", "YMD")
      .append("user", "gene")
      .append("count", "3.5")
      .append("timestamp", "1");
  docs.add(doc);

  //
  doc = new Document()
      .append("id", "J1")
      .append("query", "jack")
      .append("docId", "JML")
      .append("user", "jack")
      .append("count", "1.5")
      .append("timestamp", "1");
  //docs.add(doc);

  doc = new Document()
      .append("id", "J2")
      .append("query", "jack")
      .append("docId", "LIW")
      .append("user", "jack")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "J3")
      .append("query", "jack")
      .append("docId", "SOP")
      .append("user", "jack")
      .append("count", "4")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "J4")
      .append("query", "jack")
      .append("docId", "SR")
      .append("user", "jack")
      .append("count", "5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "J5")
      .append("query", "jack")
      .append("docId", "NL")
      .append("user", "jack")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "J6")
      .append("query", "jack")
      .append("docId", "YMD")
      .append("user", "jack")
      .append("count", "3.5")
      .append("timestamp", "1");
  docs.add(doc);

  //
  doc = new Document()
      .append("id", "L1")
      .append("query", "lisa")
      .append("docId", "JML")
      .append("user", "lisa")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "L2")
      .append("query", "lisa")
      .append("docId", "LIW")
      .append("user", "lisa")
      .append("count", "2.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "L3")
      .append("query", "lisa")
      .append("docId", "SOP")
      .append("user", "lisa")
      .append("count", "3.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "L4")
      .append("query", "lisa")
      .append("docId", "SR")
      .append("user", "lisa")
      .append("count", "3.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "L5")
      .append("query", "lisa")
      .append("docId", "NL")
      .append("user", "lisa")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "L6")
      .append("query", "lisa")
      .append("docId", "YMD")
      .append("user", "lisa")
      .append("count", "2.5")
      .append("timestamp", "1");
  docs.add(doc);

  //
  doc = new Document()
      .append("id", "M1")
      .append("query", "mick")
      .append("docId", "JML")
      .append("user", "mick")
      .append("count", "2")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "M2")
      .append("query", "mick")
      .append("docId", "LIW")
      .append("user", "mick")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "M3")
      .append("query", "mick")
      .append("docId", "SOP")
      .append("user", "mick")
      .append("count", "4")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "M4")
      .append("query", "mick")
      .append("docId", "SR")
      .append("user", "mick")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "M5")
      .append("query", "mick")
      .append("docId", "NL")
      .append("user", "mick")
      .append("count", "3")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "M6")
      .append("query", "mick")
      .append("docId", "YMD")
      .append("user", "mick")
      .append("count", "2")
      .append("timestamp", "1");
  docs.add(doc);

  //
  doc = new Document()
      .append("id", "T1")
      .append("query", "toby")
      .append("docId", "JML")
      .append("user", "toby")
      .append("count", "2")
      .append("timestamp", "1");
  //docs.add(doc);

  doc = new Document()
      .append("id", "T2")
      .append("query", "toby")
      .append("docId", "LIW")
      .append("user", "toby")
      .append("count", "3")
      .append("timestamp", "1");
  //docs.add(doc);

  doc = new Document()
      .append("id", "T3")
      .append("query", "toby")
      .append("docId", "SOP")
      .append("user", "toby")
      .append("count", "4.5")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "T4")
      .append("query", "toby")
      .append("docId", "SR")
      .append("user", "toby")
      .append("count", "4")
      .append("timestamp", "1");
  docs.add(doc);

  doc = new Document()
      .append("id", "T5")
      .append("query", "toby")
      .append("docId", "NL")
      .append("user", "toby")
      .append("count", "3")
      .append("timestamp", "1");
  //docs.add(doc);

  doc = new Document()
      .append("id", "T6")
      .append("query", "toby")
      .append("docId", "YMD")
      .append("user", "toby")
      .append("count", "1")
      .append("timestamp", "1");
  docs.add(doc);

  return docs;
}
