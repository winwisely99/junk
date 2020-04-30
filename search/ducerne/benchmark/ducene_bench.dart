// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:ducene/analysis.dart';
import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:ducene/util.dart';

class IndexWriterBenchmark {
  static Future<Null> main() async {
    final IndexWriterBenchmark bench = new IndexWriterBenchmark();
    for (int i = 0; i < 10; i++) {
      await bench.run();
    }
    await bench.runSmallBatch();
  }

  Future<Null> run() async {
    final Analyzer ws = new WhitespaceAnalyzer(); // slow new NGramAnalyzer(2);
    final IndexDirectory directory = new RAMIndexDirectory();
    final IndexWriter writer = new IndexWriter(directory);
    final int iteration = 10000;
    final Iterable<Document> docs =
        new Iterable<Document>.generate(iteration, (int i) {
      return new Document()
          .append('id', i.toString())
          .append('text', text, analyzer: ws);
    });
    final Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    await writer.write(docs);
    print('indexed ${stopwatch.elapsed.inMilliseconds} ms');
  }

  Future<Null> runSmallBatch() async {
    final Analyzer ws = new WhitespaceAnalyzer();
    final IndexHolder index =
        await DirectoryHolder.open(new RAMIndexHolderDirectory());
    final int iteration = 10000;
    final Iterable<Document> docs =
        new Iterable<Document>.generate(iteration, (int i) {
      return new Document()
          .append('id', i.toString())
          .append('text', text, analyzer: ws);
    });
    final Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    final int smallBatchSize = 10;
    Iterable<Document> d;
    final bool cond = true;
    int start = 0;
    while (cond) {
      final int end = start + smallBatchSize;
      if (end > iteration) break;
      d = docs.toList().getRange(start, end);

      final Stopwatch stopwatch2 = new Stopwatch();
      stopwatch2.start();
      await index.updateDocuments(d);
      print(
          'SmallBatches ${stopwatch2.elapsed.inMilliseconds} ms ${start}:${end}');

      start = start + smallBatchSize;
    }
    print('indexed ${stopwatch.elapsed.inMilliseconds} ms');
  }
}

const String text = '''
Dart is a general-purpose programming language originally developed
by Google and later approved as a standard by Ecma (ECMA-408).[4]
It is used to build web, server and mobile applications,
and for Internet of Things (IoT) devices.[5]
It is open-source software under a BSD license.
''';

class IndexSearcherBenchmark {
  static Future<Null> main() async {
    final IndexSearcherBenchmark bench = new IndexSearcherBenchmark();
    for (int i = 0; i < 10; i++) {
      await bench.setup();
      await bench.run();
    }
    await bench.setup2();
    await bench.run2();
  }

  Analyzer _st;
  IndexDirectory _directory;

  Future<Null> setup() async {
    _st = new StandardAnalyzer();
    _directory = new RAMIndexDirectory();
    final IndexWriter writer = new IndexWriter(_directory);
    final int iteration = 10000;
    final Iterable<Document> docs =
        new Iterable<Document>.generate(iteration, (int i) {
      return new Document()
          .append('id', i.toString())
          .append('text', text, analyzer: _st);
    });
    //Stopwatch stopwatch = new Stopwatch();
    //stopwatch.start();
    await writer.write(docs);
    //print('indexed ${stopwatch.elapsed.inMilliseconds} ms');
  }

  Future<Null> run() async {
    final IndexReader reader = await DirectoryReader.open(_directory);
    final IndexSearcher searcher = new IndexSearcher(reader);
    final BoolQuery query =
        new BoolQuery(Op.or).append('text', 'software', analyzer: _st);
    final Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    final TopDocs hits = await searcher.search(query, 10);
    assert(10000 == hits.totalHits);
    print('searched ${stopwatch.elapsed.inMilliseconds} ms');
  }

  Analyzer _st2;
  IndexHolder _index2;
  IndexHolderDirectory _directory2;

  Future<Null> setup2() async {
    _st2 = new StandardAnalyzer();
    _directory2 = new RAMIndexHolderDirectory();
    _index2 = await DirectoryHolder.open(_directory2);
    final int iteration = 10000;
    final Iterable<Document> docs =
        new Iterable<Document>.generate(iteration, (int i) {
      return new Document()
          .append('id', i.toString())
          .append('text', text, analyzer: _st);
    });
    //Stopwatch stopwatch = new Stopwatch();
    //stopwatch.start();
    await _index2.updateDocuments(docs);
    //print('indexed2 ${stopwatch.elapsed.inMilliseconds} ms');
  }

  Future<Null> run2() async {
    final IndexSearcher searcher = await _index2.newRealTimeIndexSearcher();
    final BoolQuery query =
        new BoolQuery(Op.or).append('text', 'software', analyzer: _st2);
    final Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    final TopDocs hits = await searcher.search(query, 10);
    assert(10000 == hits.totalHits);
    print('searched2 ${stopwatch.elapsed.inMilliseconds} ms');
  }
}

Future<Null> main() async {
  await IndexWriterBenchmark.main();
  await IndexSearcherBenchmark.main();
}
