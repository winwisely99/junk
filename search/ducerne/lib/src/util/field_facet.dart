// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';

import '../../src/index/index_reader.dart';

class FieldFacet {
  static Future<Map<String, FacetValue>> getCount(
      IDocSet docSet, String field, IndexReader reader) async {
    final Map<String, IDocSet> setAcc = <String, IDocSet>{};
    final Map<String, double> scoreAcc = <String, double>{};
    final int maxDoc = await reader.maxDoc();
    int i = 0;
    for (String term in await reader.terms(field)) {
      final IDocSet unionSet = await reader.postings(field, term);
      final IDocSet resultSet = unionSet.and(docSet);
      if (resultSet.docCount() > 0) {
        setAcc[term] = resultSet;
        final double score =
            resultSet.docCount() + (maxDoc / (i + 1) * 0.00000001);
        scoreAcc[term] = score;
      }
      i++;
    }
    final SplayTreeMap<double, String> sort =
        new SplayTreeMap<double, String>.fromIterables(
            scoreAcc.values, scoreAcc.keys, (double a, double b) {
      return b.compareTo(a);
    });
    final Map<String, FacetValue> ret = <String, FacetValue>{};
    for (String term in sort.values) {
      ret[term] = new FacetValue(setAcc[term]);
    }
    return ret;
  }
}

class FacetValue {
  int value;
  IDocSet docSet;
  FacetValue(this.docSet) {
    value = docSet.docCount();
  }
}
