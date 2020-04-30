// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/analysis.dart';
import 'package:ducene/util.dart';
import 'package:test/test.dart';

void main() {
  group('A group of schema', () {
    test('test schema public methods', () {
      final Schema schema = new Schema();

      final Analyzer kwd = new KeywordAnalyzer();
      final Analyzer general = new StandardAnalyzer();

      schema.addFieldType('string', kwd, kwd);
      schema.addFieldType('text_general', general, general);

      schema.addField('id', 'string', true);
      schema.addField('author_s', 'string', false);
      schema.addField('name_txt', 'text_general', true);
      schema.addField('description_txt', 'text_general', true);

      expect(schema.indexAnalyzer("id"), schema.indexAnalyzer("author_s"));
      expect(schema.indexAnalyzer("name_txt"),
          schema.indexAnalyzer("description_txt"));

      expect(schema.queryAnalyzer("id"), schema.queryAnalyzer("author_s"));
      expect(schema.queryAnalyzer("name_txt"),
          schema.queryAnalyzer("description_txt"));

      expect(schema.stored("id"), true);
      expect(schema.stored("author_s"), false);
      expect(schema.stored("name_txt"), true);
      expect(schema.stored("description_txt"), true);

      expect(schema.indexedFields(),
          <String>["id", "author_s", "name_txt", "description_txt"]);
      expect(
          schema.storedFields(), <String>["id", "name_txt", "description_txt"]);
    });
  });
}
