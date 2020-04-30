// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:ducene/index.dart';
import 'package:ducene/store.dart';
import 'package:test/test.dart';

void main() {
  group('A group of reader', () {
    IndexReader indexReader;

    test('test init', () async {
      indexReader = await DirectoryReader.open(new RAMIndexDirectory());

      expect((await indexReader.terms('id')).toList().length, 0);
      expect((await indexReader.dataFields()).toList().length, 0);
    });

    test('docSet test', () async {
      final Set<int> docIds = new Set<int>()..add(1)..add(2);
      final IDocSet docSet = new SetDocSet(new Set<int>());
      docSet.updateFromSet(docIds, 2);
      expect(docSet.length(), 2);
      expect(docSet.docCount(), 2);
      expect(docSet.toString(), docIds.join(','));
    });

    test('docSet test gap/ungap', () async {
      final Set<int> docIds = new Set<int>()
        ..add(0)
        ..add(1)
        ..add(2)
        ..add(5)
        ..add(12)
        ..add(100);
      final List<int> encoded = SetDocSet.gap(docIds);
      expect(encoded, <int>[0, 1, 1, 3, 7, 88]);

      final Uint16List buffer = new Uint16List.fromList(encoded);
      final Set<int> decoded = SetDocSet.ungap(buffer);
      expect(decoded, docIds);
    });

    test('BitDocSet test', () async {
      final int maxDoc = 100;
      final Set<int> docIds = new Set<int>()..add(10)..add(20);
      final IDocSet docSet = new BitDocSet();
      docSet.updateFromSet(docIds, maxDoc);
      expect(docSet.length(), maxDoc);
      expect(docSet.docCount(), 2);

      final Set<int> other = new Set<int>()..add(20)..add(30);
      final IDocSet otherSet = new BitDocSet();
      otherSet.updateFromSet(other, maxDoc);

      final Set<int> expected = new Set<int>()..add(20);
      final IDocSet e1 = new BitDocSet();
      e1.updateFromSet(expected, maxDoc);
      expect(docSet.and(otherSet).toString(), e1.toString());

      final Set<int> expected2 = new Set<int>()..add(10)..add(20)..add(30);
      final IDocSet e2 = new BitDocSet();
      e2.updateFromSet(expected2, maxDoc);
      expect(docSet.or(otherSet).toString(), e2.toString());

      final Set<int> expected3 = new Set<int>()..add(10);
      final IDocSet e3 = new BitDocSet();
      e3.updateFromSet(expected3, maxDoc);
      expect(docSet.not(otherSet).toString(), e3.toString());
    });

    test('docData should decode Strings', () async {
      final List<String> data = <String>['abc', 'abc', 'hhh'];
      final DocData docData = new DocData(data);
      final List<String> actualList = docData.toList();
      expect(actualList.length, 3);
      expect(actualList, data);
    });
  });
}
