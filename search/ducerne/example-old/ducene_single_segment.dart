// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
//import 'dart:io';
import 'package:ducene/analysis.dart';
import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:ducene/util.dart';

Future<Null> main() async {
  final Analyzer st = new StandardAnalyzer();

  // Store the index in memory:
  final IndexDirectory directory = new RAMIndexDirectory();
  // To store an index on disk, use this instead:
  //IndexDirectory directory = new FSIndexDirectory(new Directory("testindex"));
  final IndexWriter writer = new IndexWriter(directory);
  String text = 'This is the text of #1.';
  final Document doc1 = new Document()
      .append('id', '1')
      .append('text', text, analyzer: st)
      .append('filter', 'x')
      .append('cat', 'CAT-A')
      .append('subcat', 'CAT-A-1')
      .append('price', '80');
  text = 'This is the text of #2.';
  final Document doc2 = new Document()
      .append('id', '2')
      .append('text', text, analyzer: st)
      .append('filter', 'x')
      .append('cat', <String>['CAT-B', 'CAT-A'])
      .append('subcat', 'CAT-A-2')
      .append('price', '70');
  text = "the text which 'or' matched";
  final Document doc3 = new Document()
      .append('id', '3')
      .append('text', text, analyzer: st)
      .append('filter', 'x')
      .append('cat', 'CAT-C')
      .append('subcat', 'CAT-C-1')
      .append('price', '100');
  await writer.write(<Document>[doc1, doc2, doc3]);

  // Now search the index:
  final IndexReader reader = await DirectoryReader.open(directory);
  final IndexSearcher searcher = new IndexSearcher(reader);
  final BoolQuery query = new BoolQuery()
      .append('text', 'this text', analyzer: st)
      .addFilter(new TermQuery(new Term('filter', 'x')));
  final TopDocs hits = await searcher.search(query, 1000);
  assert(3 == await searcher.count(query));
  assert(3 == hits.totalHits);
  // Iterate through the results:
  for (ScoreDoc hit in hits.scoreDocs) {
    final Document hitDoc = await searcher.doc(hit.doc);
    assert(hitDoc.get('text').contains('the text'));
    print('${hitDoc.get('id')} : ${hit.score.toString()}');
    // Highlight:
    final String snippet =
        FieldHighlight.getSnippet(query, 'text', hitDoc.get('text'));
    assert(snippet.contains('<b>'));
    print(snippet);
  }

  // Facet + Stats:
  final Map<String, FacetValue> mainFacet =
      await FieldFacet.getCount(hits.docSet, 'cat', reader);
  final FacetValue mainFacetA = mainFacet['CAT-A'];
  assert(mainFacetA.value == 2);
  final FacetValue mainFacetB = mainFacet['CAT-B'];
  assert(mainFacetB.value == 1);
  final FacetValue mainFacetC = mainFacet['CAT-C'];
  assert(mainFacetC.value == 1);
  final StatsResult mainStatsA =
      await FieldStats.getStats(mainFacetA.docSet, 'price', reader);
  assert(mainStatsA.sum == 150 && mainStatsA.mean == 75);
  final StatsResult mainStatsB =
      await FieldStats.getStats(mainFacetB.docSet, 'price', reader);
  assert(mainStatsB.count == 1);
  final StatsResult mainStatsC =
      await FieldStats.getStats(mainFacetC.docSet, 'price', reader);
  assert(mainStatsC.min == 100 && mainStatsC.max == 100);

  final Map<String, FacetValue> subFacetA =
      await FieldFacet.getCount(mainFacetA.docSet, 'subcat', reader);
  final FacetValue subFacetA1 = subFacetA['CAT-A-1'];
  assert(subFacetA1.value == 1);
  final FacetValue subFacetA2 = subFacetA['CAT-A-2'];
  assert(subFacetA2.value == 1);
  final StatsResult subStatsA1 =
      await FieldStats.getStats(subFacetA1.docSet, 'price', reader);
  assert(subStatsA1.sum == 80);
  final StatsResult subStatsA2 =
      await FieldStats.getStats(subFacetA2.docSet, 'price', reader);
  assert(subStatsA2.sum == 70);
}
