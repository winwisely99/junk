// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';

void main() {
  group('A group of facet', () {
    test('test correct facet counts', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);

      final List<Document> d1 = <Document>[];
      for (int i = 0; i < 10; i++) {
        final Document doc = new Document();
        doc.append('id', i.toString());
        doc.append('text', 'text');
        doc.append('cat', 'A');
        d1.add(doc);
      }
      final List<Document> d2 = <Document>[];
      for (int i = 10; i < 15; i++) {
        final Document doc = new Document();
        doc.append('id', i.toString());
        doc.append('text', 'text');
        doc.append('cat', <String>['B', 'C']);
        d2.add(doc);
      }
      final List<Document> docs = <Document>[];
      docs.addAll(d1);
      docs.addAll(d2);

      await writer.write(docs);

      final IndexReader reader = await DirectoryReader.open(indexDirectory);
      final IndexSearcher searcher = new IndexSearcher(reader);

      final BoolQuery q = new BoolQuery().addQuery(new MatchAllDocsQuery());
      final TopDocs hits = await searcher.search(q, 100);

      expect(hits.totalHits, 15);

      //Stopwatch stopwatch = new Stopwatch();
      //stopwatch.start();
      //for (int i = 0; i < 100000; i++) {
      final Map<String, FacetValue> catFacet =
          await FieldFacet.getCount(hits.docSet, 'cat', reader);
      expect(catFacet['A'].value, 10);
      expect(catFacet['B'].value, 5);
      expect(catFacet['C'].value, 5);
      //}
      //print(stopwatch.elapsedMilliseconds);
    });
  });
}
