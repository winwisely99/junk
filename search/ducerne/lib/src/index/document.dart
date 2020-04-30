// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import '../../src/analysis/analyzer.dart';

/// Documents are the unit of indexing and search. A Document is a set of [Field].
class Document {
  List<Field> fields = <Field>[];
  Document add(Field field) {
    fields.add(field);
    return this;
  }

  static Analyzer defaultAnalyzer = new KeywordAnalyzer();
  Document append(String name, Object text,
      {Analyzer analyzer, bool stored: true}) {
    List<String> txt = <String>[];
    if (text is String) {
      txt.add(text);
    } else if (text is Iterable<String>) {
      txt = text.toList();
    }
    add(new Field(
        name, txt, (analyzer == null) ? defaultAnalyzer : analyzer, stored));
    return this;
  }

  String get(String name) {
    final List<String> values = getValues(name);
    return (values != null) ? values[0] : null;
  }

  List<String> getValues(String name) {
    final List<Field> fs = fields.where((Field e) => e.name == name).toList();
    final Field f =
        (fs.length != 0) ? fs[0] : new Field(null, null, null, null);
    return (f.text != null) ? f.text : null;
  }
}

/// A field is a section of a [Document].
class Field {
  final String name;
  final List<String> text;
  final Analyzer analyzer;
  final bool stored;
  Field(this.name, this.text, this.analyzer, this.stored);
}
