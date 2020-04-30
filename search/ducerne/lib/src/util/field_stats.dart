// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../src/index/index_reader.dart';

class FieldStats {
  static Future<StatsResult> getStats(
      IDocSet docSet, String field, IndexReader reader) async {
    final List<double> acc = <double>[];
    for (int docId in docSet.toIterable()) {
      final List<String> values = await reader.dataValues(field, docId);
      for (String v in values) {
        acc.add(double.parse(v));
      }
    }
    acc.sort();
    final int count = acc.length;
    final double sum = acc.reduce((double a, double b) => a + b);
    return new StatsResult(
        acc.first, acc.last, count.toDouble(), sum, sum / count);
  }
}

class StatsResult {
  double min;
  double max;
  double count;
  double sum;
  double mean;
  StatsResult(this.min, this.max, this.count, this.sum, this.mean);
}
