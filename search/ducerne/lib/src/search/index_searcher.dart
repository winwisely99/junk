// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import '../../src/index/document.dart';
import '../../src/index/index_reader.dart';
import 'query.dart';

/// Implements search over a single [IndexReader].
///
/// Applications usually need only call the inherited [search(BoolQuery,int)] method.
/// For performance reasons, if your index is unchanging,
/// you should share a single IndexSearcher instance across multiple searches
/// instead of creating a new one per-search.
class IndexSearcher {
  final IndexReader _reader;

  IndexSearcher(this._reader);

  IndexReader get reader => _reader;

  Future<int> count(BoolQuery query) async {
    return (await search(query, await _reader.maxDoc(),
            scoreSort: new NoOpScoreSort()))
        .totalHits;
  }

  Future<Document> doc(int docId, {Iterable<String> fieldsToLoad}) async {
    return await _reader.document(docId, fieldsToLoad: fieldsToLoad);
  }

  static ScoreSort defaultScoreSort = new MatchScoreSort();

  Future<TopDocs> search(BoolQuery query, int n, {ScoreSort scoreSort}) async {
    final int maxDoc = await _reader.maxDoc();
    final IDocSet filtered = await _getDocSet(Op.and, query.filters, maxDoc);
    if (query.filters.length > 0 && filtered.docCount() == 0) {
      return new TopDocs(0, <ScoreDoc>[new ScoreDoc(-1, double.NAN)], filtered);
    }
    IDocSet mainSet = await _getDocSet(query.op, query.queries, maxDoc);
    if (filtered.docCount() > 0) {
      mainSet = Query.unionDocSet(Op.and, filtered, mainSet);
    }
    if (mainSet.docCount() == 0) {
      return new TopDocs(0, <ScoreDoc>[new ScoreDoc(-1, double.NAN)], mainSet);
    }

    final ScoreSort scoreSorter =
        (scoreSort == null) ? defaultScoreSort : scoreSort;
    final Map<int, double> docIdScore =
        await scoreSorter.scoreThenSort(query, mainSet, _reader);

    final int totalHits = docIdScore.length;
    final int max = (totalHits < n) ? totalHits : n;
    final List<ScoreDoc> scoreDocs = <ScoreDoc>[];
    for (int docId in docIdScore.keys.toList().getRange(0, max)) {
      final ScoreDoc scoreDoc = new ScoreDoc(docId, docIdScore[docId]);
      scoreDocs.add(scoreDoc);
    }
    return new TopDocs(totalHits, scoreDocs, mainSet);
  }

  Future<IDocSet> _getDocSet(Op op, List<Query> queries, int maxDoc) async {
    IDocSet ret = IDocSet.of(maxDoc);
    bool isFirst = true;
    for (Query query in queries) {
      IDocSet docSet = await query.match(this);
      if (docSet == null) docSet = IDocSet.of(maxDoc);
      if (isFirst) {
        ret = docSet;
        isFirst = false;
        continue;
      }
      ret = Query.unionDocSet(op, ret, docSet);
    }
    return ret;
  }
}

class TopDocs {
  final int totalHits;
  final List<ScoreDoc> scoreDocs;
  final IDocSet docSet;
  TopDocs(this.totalHits, this.scoreDocs, this.docSet);
}

class ScoreDoc {
  final int doc;
  final double score;
  ScoreDoc(this.doc, this.score);
}

abstract class ScoreSort {
  static ScoreSort indexed() => new DocIdSort(false);
  static ScoreSort reversed() => new DocIdSort(true);
  Future<Map<int, double>> scoreThenSort(
      BoolQuery query, IDocSet docSet, IndexReader reader);
}

class DocIdSort extends ScoreSort {
  final bool _reversed;
  DocIdSort(this._reversed);
  @override
  Future<Map<int, double>> scoreThenSort(
      BoolQuery query, IDocSet docSet, IndexReader reader) async {
    final List<int> docIdsList = docSet.toIterable().toList();
    if (!_reversed) {
      docIdsList.sort();
      return new Map<int, double>.fromIterable(docIdsList,
          key: (int e) => e, value: (int e) => 1.00);
    } else {
      return new Map<int, double>.fromIterable(docIdsList.reversed.toList(),
          key: (int e) => e, value: (int e) => 1.00);
    }
  }
}

class NoOpScoreSort extends ScoreSort {
  @override
  Future<Map<int, double>> scoreThenSort(
      BoolQuery query, IDocSet docSet, IndexReader reader) async {
    return new Map<int, double>.fromIterable(docSet.toIterable(),
        key: (int e) => e, value: (int e) => 1.00);
  }
}

class MatchScoreSort extends ScoreSort {
  @override
  Future<Map<int, double>> scoreThenSort(
      BoolQuery query, IDocSet docSet, IndexReader reader) async {
    final Map<int, double> m = <int, double>{};
    final int maxDoc = await reader.maxDoc();
    for (Query q in query.queries) {
      final IDocSet queryHitSet = docSet.and(q.matchedCache);
      for (int docId in queryHitSet.toIterable()) {
        if (m[docId] == null) {
          m[docId] = q.score() + (maxDoc / (docId + 1) * 0.00000001);
        } else {
          m[docId] = m[docId] + q.score();
        }
      }
    }
    final SplayTreeMap<double, int> sort =
        new SplayTreeMap<double, int>.fromIterables(m.values, m.keys,
            (double a, double b) {
      return b.compareTo(a);
    });
    return new Map<int, double>.fromIterables(sort.values, sort.keys);
  }
}

class TFIDFScoreSort extends ScoreSort {
  @override
  Future<Map<int, double>> scoreThenSort(
      BoolQuery query, IDocSet docSet, IndexReader reader) async {
    final Map<int, double> m = <int, double>{};
    final int maxDoc = await reader.maxDoc();
    final int docCount = (await reader.liveDocs()).docCount();
    for (Query q in query.queries) {
      final int docFreq = await _docFreq(q, reader);
      final IDocSet queryHitSet = docSet.and(q.matchedCache);
      for (int docId in queryHitSet.toIterable()) {
        final int termFreq = 1; //TODO
        final double boost = _boost(q);
        if (m[docId] == null) {
          m[docId] = _score(termFreq, docFreq, docCount, boost) +
              (maxDoc / (docId + 1) * 0.00000001);
        } else {
          m[docId] = m[docId] + _score(termFreq, docFreq, docCount, boost);
        }
      }
    }
    final SplayTreeMap<double, int> sort =
        new SplayTreeMap<double, int>.fromIterables(m.values, m.keys,
            (double a, double b) {
      return b.compareTo(a);
    });
    return new Map<int, double>.fromIterables(sort.values, sort.keys);
  }

  Future<int> _docFreq(Query q, IndexReader reader) async {
    if (q is TermQuery) {
      return await reader.docFreq(q.term.field, q.term.text);
    } else {
      return 1;
    }
  }

  double _boost(Query q) {
    if (q is TermQuery) {
      return q.term.boost;
    } else {
      return 1.00;
    }
  }

  double _score(int termFreq, int docFreq, int docCount, double boost) {
    return _tf(termFreq) * _idf(docFreq, docCount) * boost;
  }

  double _tf(int termFreq) {
    return sqrt(termFreq);
  }

  double _idf(int docFreq, int docCount) {
    return log((docCount + 1.00) / (docFreq + 1.00)) + 1.00;
  }
}
