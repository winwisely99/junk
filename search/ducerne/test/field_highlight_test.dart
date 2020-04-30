// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/analysis.dart';
import 'package:ducene/search.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';

void main() {
  group('A group of fieldHighlight', () {
    Analyzer ws;

    setUp(() {
      ws = new WhitespaceAnalyzer();
    });

    test('test getTerms()', () {
      final BoolQuery q = new BoolQuery()
        ..append("f1", "f1-1", analyzer: ws)
        ..append("f1", "f1-2", analyzer: ws)
        ..append("f2", "f2-1");
      expect(FieldHighlight.getTerms(q, "f1"), <String>["f1-1", "f1-2"]);
    });

    test('test getOffsets()', () {
      final List<String> terms = <String>[
        "keyword",
        'bb',
        "wo",
        "word",
        "a keyword bb",
        "a keyword bb",
        " keyword ",
        " keyword",
        "cc"
      ];
      final String text = "AAA keyword BBB CCC";
      expect(FieldHighlight.getOffsets(terms, text), <Map<int, int>>[
        <int, int>{2: 14},
        <int, int>{16: 18}
      ]);
    });

    test('test getOffsets()', () {
      final List<String> terms = <String>["aaa bbb", "bbb ccc"];
      final String text = "AAA BBB CCC";
      expect(FieldHighlight.getOffsets(terms, text), <Map<int, int>>[
        <int, int>{0: 7}
      ]);
    });

    test('test markTags()', () {
      final String text = "0123456789";
      final String r = FieldHighlight.markTags(<Map<int, int>>[
        <int, int>{1: 3},
        <int, int>{5: 7}
      ], text, '<b>', '</b>');
      expect(r, '0<b>12</b>34<b>56</b>789');
    });

    test('test getSnippet()', () {
      final BoolQuery q = new BoolQuery()
          .append("f1", "keyword", analyzer: ws)
          .append("f1", "bbb", analyzer: ws);
      final String text = "AAA keyword BBB";
      expect(FieldHighlight.getSnippet(q, 'f1', text),
          'AAA <b>keyword</b> <b>BBB</b>');
    });

    //####  sample tests ####//
    final String field = 'dummy';
    final String text = 'AAA Keyword BBB';

    test('test whitespace', () {
      final BoolQuery q =
          new BoolQuery().append(field, "Keyword", analyzer: ws);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>Keyword</b> BBB");
    });

    test('test whitespace lower input', () {
      final BoolQuery q =
          new BoolQuery().append(field, "keyword", analyzer: ws);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>Keyword</b> BBB");
    });

    final Analyzer uniGram = new NGramAnalyzer(1);

    test('test uniGram', () {
      final BoolQuery q = new BoolQuery().append(field, "K", analyzer: uniGram);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>K</b>eyword BBB");
    });

    final Analyzer hl = new UniGramAnalyzer();

    test('test hl', () {
      final BoolQuery q = new BoolQuery().append(field, "K", analyzer: hl);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>K</b>eyword BBB");
    });

    test('test uniGram lower input', () {
      final BoolQuery q = new BoolQuery().append(field, "k", analyzer: uniGram);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>K</b>eyword BBB");
    });

    test('test hl lower input', () {
      final BoolQuery q = new BoolQuery().append(field, "k", analyzer: hl);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>K</b>eyword BBB");
    });

    test('test uniGram 2 char', () {
      final BoolQuery q =
          new BoolQuery().append(field, "Ke", analyzer: uniGram);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>K</b><b>e</b>yword BBB");
    });

    test('test hl 2 char', () {
      final BoolQuery q = new BoolQuery().append(field, "Ke", analyzer: hl);
      final String r = FieldHighlight.getSnippet(q, field, text);
      expect(r, "AAA <b>K</b><b>e</b>yword BBB");
    });
  });
}
