// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import '../../src/analysis/analyzer.dart';

/// A utility class to maintain [SchemaFieldType] and [SchemaField].
class Schema {
  final List<SchemaFieldType> _fieldTypes = <SchemaFieldType>[];
  final List<SchemaField> _fields = <SchemaField>[];
  Schema();
  void addFieldType(
      String name, Analyzer indexAnalyzer, Analyzer queryAnalyzer) {
    _fieldTypes.add(new SchemaFieldType(name, indexAnalyzer, queryAnalyzer));
  }

  void addField(String fieldName, String fieldTypeName, bool stored) {
    _fields.add(new SchemaField(
        fieldName,
        _fieldTypes
            .where((SchemaFieldType e) => e.name == fieldTypeName)
            .toList()[0],
        stored));
  }

  SchemaField field(String name) {
    return _fields.where((SchemaField e) => e.name == name).toList()[0];
  }

  SchemaFieldType fieldType(String name) {
    return _fieldTypes.where((SchemaFieldType e) => e.name == name).toList()[0];
  }

  Analyzer indexAnalyzer(String name) => field(name).fieldType.indexAnalyzer;
  Analyzer queryAnalyzer(String name) => field(name).fieldType.queryAnalyzer;
  bool stored(String name) => field(name).stored;
  List<String> indexedFields() =>
      _fields.map((SchemaField e) => e.name).toList();
  List<String> storedFields() => _fields
      .where((SchemaField e) => e.stored == true)
      .map((SchemaField e) => e.name)
      .toList();
}

class SchemaFieldType {
  final String name;
  final Analyzer indexAnalyzer;
  final Analyzer queryAnalyzer;
  SchemaFieldType(this.name, this.indexAnalyzer, this.queryAnalyzer);
}

class SchemaField {
  final String name;
  final SchemaFieldType fieldType;
  bool stored;
  SchemaField(this.name, this.fieldType, this.stored);
}
