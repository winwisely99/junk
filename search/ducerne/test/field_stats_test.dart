// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';

void main() {
  group('A group of stats', () {
    test('test correct stats', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);

      final List<Document> d1 = <Document>[];
      for (int i = 0; i < 10; i++) {
        final Document doc = new Document();
        doc.append('id', i.toString());
        doc.append('text', 'text');
        doc.append('quantity', '3');
        d1.add(doc);
      } //30
      final List<Document> d2 = <Document>[];
      for (int i = 10; i < 15; i++) {
        final Document doc = new Document();
        doc.append('id', i.toString());
        doc.append('text', 'text');
        doc.append('quantity', <String>['4', '5']);
        d2.add(doc);
      } //25
      final List<Document> docs = <Document>[];
      docs.addAll(d1);
      docs.addAll(d2);

      await writer.write(docs);

      final IndexReader reader = await DirectoryReader.open(indexDirectory);
      final IndexSearcher searcher = new IndexSearcher(reader);

      final BoolQuery q = new BoolQuery().addQuery(new MatchAllDocsQuery());
      final TopDocs hits = await searcher.search(q, 100);

      expect(hits.totalHits, 15);

      final StatsResult quantityStats =
          await FieldStats.getStats(hits.docSet, 'quantity', reader);
      expect(quantityStats.min, 3);
      expect(quantityStats.max, 5);
      expect(quantityStats.count, 20);
      expect(quantityStats.sum, 75);
      expect(quantityStats.mean, 75 / 20);
    });
  });
}
