// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:ducene/analysis.dart';
import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/util.dart';

Future<Null> main() async {
  // use Analyzers to split text into tokens
  final Analyzer st = new StandardAnalyzer();
  // open an index holder
  final IndexHolder index =
      await DirectoryHolder.open(new RAMIndexHolderDirectory());
  // create documents
  final List<Document> addDocs = <Document>[
    new Document().append("id", "1").append("text", "White dog", analyzer: st),
    new Document().append("id", "2").append("text", "White cat", analyzer: st)
  ];
  // add documents
  await index.updateDocuments(addDocs);
  // open a searcher
  IndexSearcher searcher = await index.newRealTimeIndexSearcher();
  // count by query
  int count = await searcher.count(new BoolQuery().append("text", "white"));
  assert(count == 2);
  count = await searcher.count(new BoolQuery().append("text", "dog"));
  assert(count == 1);
  count = await searcher.count(new BoolQuery().append("text", "cat"));
  assert(count == 1);
  count = await searcher.count(new BoolQuery().append("text", "fox"));
  assert(count == 0);
  // create new document for update
  final List<Document> updateDocs = <Document>[
    new Document().append("id", "1").append("text", "White fox", analyzer: st)
  ];
  // update the document
  await index.updateDocuments(updateDocs);
  // open a searcher again
  searcher = await index.newRealTimeIndexSearcher();
  // count by query
  count = await searcher.count(new BoolQuery().append("text", "white"));
  assert(count == 2);
  count = await searcher.count(new BoolQuery().append("text", "dog"));
  assert(count == 0);
  count = await searcher.count(new BoolQuery().append("text", "cat"));
  assert(count == 1);
  count = await searcher.count(new BoolQuery().append("text", "fox"));
  assert(count == 1);
  // delete by query
  await index.deleteDocuments(new BoolQuery().append("id", "1"));
  // open a searcher again
  searcher = await index.newRealTimeIndexSearcher();
  // count by query
  count = await searcher.count(new BoolQuery().append("text", "white"));
  assert(count == 1);
  count = await searcher.count(new BoolQuery().append("text", "dog"));
  assert(count == 0);
  count = await searcher.count(new BoolQuery().append("text", "cat"));
  assert(count == 1);
  count = await searcher.count(new BoolQuery().append("text", "fox"));
  assert(count == 0);
  // merge index segments
  await index.forceMerge();
}
