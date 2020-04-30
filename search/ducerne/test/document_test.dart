// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/analysis.dart';
import 'package:ducene/index.dart';
import 'package:test/test.dart';

void main() {
  group('A group of document', () {
    Analyzer kw, ws;

    setUp(() {
      kw = Document.defaultAnalyzer;
      ws = new WhitespaceAnalyzer();
    });

    test('get()', () {
      final Document doc = new Document();
      doc.append(('f1'), 'f1 text');
      doc.add(new Field(('f2'), <String>['f2 text'], ws, true));

      expect(doc.get('f1'), 'f1 text');
      expect(doc.get('f2'), 'f2 text');
    });

    test('fields', () {
      final Document doc = new Document();
      doc.append(('f1'), 'f1 text');
      doc.add(new Field(('f2'), <String>['f2 text'], ws, true));

      final List<Field> fields = doc.fields;
      expect(fields[0].name, 'f1');
      expect(fields[0].text, <String>['f1 text']);
      expect(fields[0].analyzer, kw);
      expect(fields[1].name, 'f2');
      expect(fields[1].text, <String>['f2 text']);
      expect(fields[1].analyzer, ws);
    });
  });
}
