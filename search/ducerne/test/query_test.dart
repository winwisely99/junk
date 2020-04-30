// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/store.dart';
import 'package:test/test.dart';

void main() {
  group('A group of query', () {
    test('test bool op', () async {
      final IndexDirectory indexDirectory = new RAMIndexDirectory();
      final IndexWriter writer = new IndexWriter(indexDirectory);

      final Document doc1 = new Document();
      doc1.append("id", 'xx');
      final Document doc2 = new Document();
      doc2.append("id", 'yy');

      await writer.write(<Document>[doc1, doc2]);

      final IndexReader reader = await DirectoryReader.open(indexDirectory);
      final IndexSearcher searcher = new IndexSearcher(reader);

      BoolQuery q = new BoolQuery().append('id', 'xx').append('id', 'yy');
      expect(await searcher.count(q), 2);

      q = new BoolQuery(Op.or).append('id', 'xx').append('id', 'yy');
      expect(await searcher.count(q), 2);

      q = new BoolQuery(Op.or).append('id', 'xx').append('id', 'aa');
      expect(await searcher.count(q), 1);

      q = new BoolQuery(Op.and).append('id', 'xx').append('id', 'yy');
      expect(await searcher.count(q), 0);

      q = new BoolQuery(Op.and).append('id', 'xx').append('id', 'aa');
      expect(await searcher.count(q), 0);

      q = new BoolQuery(Op.or).append('id', 'yy');
      expect(await searcher.count(q), 1);

      q = new BoolQuery(Op.and).append('id', 'yy');
      expect(await searcher.count(q), 1);
    });
  });
}
