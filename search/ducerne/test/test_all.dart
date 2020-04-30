// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'analyzer_test.dart' as analyzer;
import 'document_test.dart' as document;
import 'field_facet_test.dart' as facet;
import 'field_highlight_test.dart' as highlight;
import 'field_stats_test.dart' as stats;
import 'index_directory_test.dart' as directory;
import 'index_holder_test.dart' as holder;
import 'index_reader_test.dart' as reader;
import 'index_searcher_test.dart' as searcher;
import 'index_writer_test.dart' as writer;
import 'query_test.dart' as query;
import 'recs_builder_test.dart' as recs;
import 'schema_test.dart' as schema;
import 'sembast_index_directory_test.dart' as sb;

void main() {
  group('analyzer', analyzer.main);
  group('document', document.main);

  group('facet', facet.main);
  group('stats', stats.main);
  group('highlight', highlight.main);

  group('directory', directory.main);
  group('reader', reader.main);
  group('searcher', searcher.main);
  group('writer', writer.main);

  group('query', query.main);
  group('schema', schema.main);
  group('holder', holder.main);
  group('recs', recs.main);

  group('sb', sb.main);
}
