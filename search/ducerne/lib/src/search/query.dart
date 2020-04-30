// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../src/analysis/analyzer.dart';
import '../../src/index/index_reader.dart';
import 'index_searcher.dart';

class BoolQuery {
  Op _op;
  BoolQuery([Op op]) {
    if (op == null) op = Op.or;
    _op = op;
  }
  final List<Query> _queries = <Query>[];
  final List<Query> _filters = <Query>[];
  BoolQuery addQuery(Query query) {
    _queries.add(query);
    return this;
  }

  BoolQuery addFilter(Query query) {
    _filters.add(query);
    return this;
  }

  static Analyzer defaultAnalyzer = new KeywordAnalyzer();
  BoolQuery append(String field, String text,
      {Analyzer analyzer, double boost: 1.00}) {
    final Analyzer ana = (analyzer == null) ? defaultAnalyzer : analyzer;
    for (String token in ana.getTokens(text)) {
      addQuery(new TermQuery(new Term(field, token, boost: boost)));
    }
    return this;
  }

  List<Query> get queries => _queries;
  List<Query> get filters => _filters;
  Op get op => _op;
}

enum Op { and, or }

/// The abstract base class for queries.
abstract class Query {
  IDocSet _matched;
  IDocSet get matchedCache => _matched;
  Future<IDocSet> match(IndexSearcher searcher) async {
    _matched = await _matchDocSet(searcher);
    return _matched;
  }

  Future<IDocSet> _matchDocSet(IndexSearcher searcher);
  double score();

  static IDocSet unionDocSet(Op op, IDocSet from, IDocSet other) {
    IDocSet ret = IDocSet.newDocSetFromDocSet(from);
    switch (op) {
      case Op.and:
        ret = ret.and(other);
        break;
      case Op.or:
        ret = ret.or(other);
        break;
    }
    return ret;
  }
}

class TermQuery extends Query {
  final Term _term;
  TermQuery(this._term);
  Term get term => _term;
  @override
  Future<IDocSet> _matchDocSet(IndexSearcher searcher) async {
    final IDocSet matched =
        (await searcher.reader.postings(_term.field, _term.text));
    final IDocSet liveDocs = (await searcher.reader.liveDocs());
    return Query.unionDocSet(Op.and, matched, liveDocs);
  }

  @override
  double score() => (1.00 * _term.boost);
}

class Term {
  final String field;
  final String text;
  double boost;
  Term(this.field, this.text, {double boost: 1.00}) {
    this.boost = boost;
  }
}

class MatchAllDocsQuery extends Query {
  @override
  Future<IDocSet> _matchDocSet(IndexSearcher searcher) async {
    return (await searcher.reader.liveDocs());
  }

  @override
  double score() => 1.00;
}

class MatchNoDocsQuery extends Query {
  @override
  Future<IDocSet> _matchDocSet(IndexSearcher searcher) async {
    return IDocSet.of(await searcher.reader.maxDoc());
  }

  @override
  double score() => 0.00;
}

class RangeQuery extends Query {
  final String field;
  final double lower;
  final double upper;
  RangeQuery(this.field, this.lower, this.upper);
  @override
  Future<IDocSet> _matchDocSet(IndexSearcher searcher) async {
    final int maxDoc = await searcher.reader.maxDoc();
    IDocSet matched = IDocSet.of(maxDoc);
    final Iterable<String> terms = await searcher.reader.terms(field);
    if (terms == null) return matched;
    bool isFirst = true;
    for (String term in terms) {
      final double value = double.parse(term);
      IDocSet docSet = IDocSet.of(maxDoc);
      if (lower <= value && value <= upper) {
        docSet = (await searcher.reader.postings(field, term));
      }
      if (isFirst) {
        matched = docSet;
        isFirst = false;
        continue;
      }
      matched = Query.unionDocSet(Op.or, matched, docSet);
    }
    final IDocSet liveDocs = (await searcher.reader.liveDocs());
    return Query.unionDocSet(Op.and, matched, liveDocs);
  }

  @override
  double score() => 0.00;
}

class TermsQuery extends Query {
  final List<Term> _terms;
  TermsQuery(this._terms);
  @override
  Future<IDocSet> _matchDocSet(IndexSearcher searcher) async {
    IDocSet orIds = IDocSet.of(await searcher.reader.maxDoc());
    for (Term term in _terms) {
      final TermQuery tq = new TermQuery(term);
      final IDocSet docSet = await tq.match(searcher);
      orIds = Query.unionDocSet(Op.or, orIds, docSet);
    }
    return orIds;
  }

  @override
  double score() => 0.00;
}

class NotQuery extends Query {
  final List<Term> _prohibitTerms;
  NotQuery(this._prohibitTerms);
  @override
  Future<IDocSet> _matchDocSet(IndexSearcher searcher) async {
    IDocSet prohibitedIds = IDocSet.of(await searcher.reader.maxDoc());
    final TermsQuery tsq = new TermsQuery(_prohibitTerms);
    prohibitedIds = await tsq.match(searcher);
    final Query q = new MatchAllDocsQuery();
    final IDocSet allIds = await q.match(searcher);
    return allIds.not(prohibitedIds);
  }

  @override
  double score() => 0.00;
}
