// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import '../analysis/analyzer.dart';
import '../search/query.dart';

class FieldHighlight {
  static String getSnippet(BoolQuery query, String field, String text) {
    final List<String> terms = getTerms(query, field);
    final List<Map<int, int>> offsets = getOffsets(terms, text);
    return markTags(offsets, text, '<b>', '</b>');
  }

  static List<String> getTerms(BoolQuery query, String field) {
    return query.queries.where((Query e) {
      final TermQuery tq = e;
      return tq.term.field == field;
    }).map((Query e) {
      final TermQuery tq = e;
      return tq.term.text;
    }).toList();
  }

  static String markTags(
      List<Map<int, int>> offset, String text, String preTag, String postTag) {
    final List<int> startOffsets =
        offset.map((Map<int, int> e) => e.keys.toList()[0]).toList();
    final List<int> endOffsets =
        offset.map((Map<int, int> e) => e.values.toList()[0]).toList();
    final StringBuffer sb = new StringBuffer();
    int i = 0;
    for (String token in new UniGramAnalyzer().getTokens(text)) {
      if (startOffsets.contains(i) && !endOffsets.contains(i)) {
        sb.write(preTag);
      } else if (endOffsets.contains(i) && !startOffsets.contains(i)) {
        sb.write(postTag);
      } else if (endOffsets.contains(i) && startOffsets.contains(i)) {
        sb.write(postTag);
        sb.write(preTag);
      }
      sb.write(token);
      i++;
    }
    if (endOffsets.contains(i)) {
      sb.write(postTag);
    }
    return sb.toString();
  }

  static List<Map<int, int>> getOffsets(List<String> terms, String text) {
    // dedupe terms
    final Set<String> termsSet = new Set<String>.from(terms);
    // tokenize both of param
    final List<List<String>> termsList = <List<String>>[];
    for (String term in termsSet) {
      final List<String> tokens = new NGramAnalyzer(1).getTokens(term).toList();
      termsList.add(tokens);
    }
    final List<String> textTokens =
        new NGramAnalyzer(1).getTokens(text).toList();
    // try to match both of param
    final List<Map<int, int>> list = <Map<int, int>>[];
    for (List<String> tokens in termsList) {
      final int startIndex = textTokens.join().indexOf(tokens.join());
      if (startIndex == -1) continue;
      final int endIndex = startIndex + tokens.length;
      if (endIndex > textTokens.length) continue;
      final Iterable<String> textSequence =
          textTokens.getRange(startIndex, endIndex);
      int i = 0;
      bool found = false;
      for (String c in textSequence) {
        if (c == tokens[i]) {
          found = true;
        } else {
          found = false;
          break;
        }
        i++;
      }
      if (found) {
        final Map<int, int> m = <int, int>{};
        m[startIndex] = endIndex;
        list.add(m);
      }
    }
    // remove within/overlap to extract offsets
    final List<Map<int, int>> clone = <Map<int, int>>[];
    for (Map<int, int> e in list) {
      clone.add(e);
    }
    final List<Map<int, int>> ret = <Map<int, int>>[];
    int curPos = 0;
    for (Map<int, int> cur in list) {
      final int curStart = cur.keys.toList()[0];
      final int curEnd = cur.values.toList()[0];
      bool within = false;
      int pos = 0;
      for (Map<int, int> x in clone) {
        final int s = x.keys.toList()[0];
        final int e = x.values.toList()[0];
        if (curPos != pos && s <= curStart && curEnd <= e) {
          within = true;
          break;
        }
        pos++;
      }
      bool overlap = false;
      pos = 0;
      for (Map<int, int> x in clone) {
        final int s = x.keys.toList()[0];
        final int e = x.values.toList()[0];
        if (curPos != pos && (s <= curStart && curStart < e)) {
          overlap = true;
          break;
        }
        pos++;
      }
      if (!within && !overlap) {
        ret.add(cur);
      }
      curPos++;
    }
    // sort
    ret.sort((Map<int, int> a, Map<int, int> b) =>
        a.keys.toList()[0] - b.keys.toList()[0]);
    return ret;
  }
}
