// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bit_set/bit_set.dart';

import '../../src/index/document.dart';
import '../../src/store/index_directory.dart';

/// IndexReader is providing an interface for accessing a point-in-time view of an index.
///
/// Any changes made to the index via IndexWriter will not be visible until a new IndexReader is opened.
/// It's best to use [DirectoryReader.open(IndexDirectory)] to obtain an IndexReader.
class IndexReader {
  IndexInfoSource _indexInfoSource;
  LiveDocsSource _liveDocsSource;
  IndexSource _indexSource;
  DataSource _dataSource;

  final IndexInfo _indexInfoCache = IndexInfo.empty();
  final IDocSet _liveDocsCache = IDocSet.empty();
  final Index _indexesCache = Index.empty();
  final FieldData _dataCache = FieldData.empty();

  IndexReader(IndexDirectory directory) {
    directory.initInput();
    _indexInfoSource = directory.inputIndexInfo();
    _liveDocsSource = directory.inputLiveDocs();
    _indexSource = directory.inputIndex();
    _dataSource = directory.inputData();
  }

  Future<Null> read() async {
    await _indexInfo();
    await _liveDocs();
    if (_indexesCache.length() == 0) {
      await _indexSource.read(_indexesCache);
    }
    await _data();
  }

  Future<Null> _indexInfo() async {
    if (_indexInfoCache.length() == 0) {
      await _indexInfoSource.read(_indexInfoCache);
    }
  }

  Future<Null> _liveDocs() async {
    if (_liveDocsCache.docCount() == 0) {
      await _liveDocsSource.read(_liveDocsCache);
    }
  }

  Future<Null> _data() async {
    if (_dataCache.length() == 0) {
      await _dataSource.fields(_dataCache);
    }
  }

  Future<int> maxDoc() async {
    await _indexInfo();
    return _indexInfoCache.getMaxDoc();
  }

  Future<IDocSet> liveDocs() async {
    await _liveDocs();
    return _liveDocsCache;
  }

  Future<Iterable<String>> terms(String field) async {
    if (_indexesCache.length() == 0 || _indexesCache[field] == null) {
      await _indexSource.terms(field, _indexesCache);
    }
    final Map<String, IDocSet> r = _indexesCache[field];
    return (r == null) ? <String>[] : r.keys;
  }

  Future<IDocSet> postings(String field, String term) async {
    if (_indexesCache.length == 0 ||
        _indexesCache[field] == null ||
        _indexesCache[field][term] == null) {
      await _indexSource.postings(field, term, _indexesCache);
    }
    final IDocSet r = _indexesCache[field][term];
    return (r == null) ? IDocSet.of(await maxDoc()) : r;
  }

  Future<int> docFreq(String field, String text) async {
    final IDocSet docSet = await postings(field, text);
    return docSet.docCount();
  }

  Future<Iterable<String>> dataFields() async {
    await _data();
    final Iterable<String> r = _dataCache.keys;
    return (r == null) ? <String>[] : r;
  }

  Future<List<String>> dataValues(String field, int docId) async {
    if (_dataCache.length() == 0 ||
        _dataCache[field] == null ||
        _dataCache[field][docId] == null) {
      await _dataSource.values(field, docId, _dataCache);
    }
    final DocData r = _dataCache[field][docId];
    return (r == null) ? <String>[] : r.toList();
  }

  Future<Document> document(int docId, {Iterable<String> fieldsToLoad}) async {
    final Iterable<String> fields =
        (fieldsToLoad != null) ? fieldsToLoad : await dataFields();
    final Document ret = new Document();
    for (String field in fields) {
      final List<String> text = await dataValues(field, docId);
      ret.add(new Field(field, text, null, null));
    }
    return ret;
  }
}

class DirectoryReader {
  static Future<IndexReader> open(IndexDirectory directory) async {
    final IndexReader ir = new IndexReader(directory);
    await ir.read();
    return ir;
  }
}

class IndexInfo {
  Map<String, String> _info;
  IndexInfo(Map<String, String> info) {
    updateFromMap(info);
  }
  void updateFromMap(Map<String, String> map) {
    _info = map;
  }

  Map<String, String> toMap() {
    return _info;
  }

  int length() => _info.length;
  int getMaxDoc() {
    final String v = _info['maxDoc'];
    return (v != null) ? int.parse(v) : 0;
  }

  void setMaxDoc(int v) {
    _info['maxDoc'] = v.toString();
  }

  @override
  String toString() {
    final StringBuffer sb = new StringBuffer();
    sb.writeAll(_info.keys, ',');
    sb.write(':');
    sb.writeAll(_info.values, ',');
    return sb.toString();
  }

  static Map<String, String> getMap(String s) {
    final List<String> lines = s.split(':');
    final List<String> columns = lines[0].split(',');
    final List<String> values = lines[1].split(',');
    return new Map<String, String>.fromIterables(columns, values);
  }

  static IndexInfo empty() {
    return new IndexInfo(<String, String>{});
  }
}

class Index {
  final Map<String, Map<String, IDocSet>> _fields;
  Index(this._fields);
  int length() => _fields.length;
  Map<String, IDocSet> operator [](String key) => _fields[key];
  void operator []=(String key, Map<String, IDocSet> value) {
    _fields[key] = value;
  }

  Iterable<String> get keys => _fields.keys;
  void clear() => _fields.clear();
  static Index empty() {
    return new Index(emptyFields());
  }

  static Map<String, Map<String, IDocSet>> emptyFields() {
    return <String, Map<String, IDocSet>>{};
  }

  static Map<String, IDocSet> emptyTermDictionary() {
    return <String, IDocSet>{};
  }
}

class FieldData {
  final Map<String, Map<int, DocData>> _fields;
  FieldData(this._fields);
  int length() => _fields.length;
  Map<int, DocData> operator [](String key) => _fields[key];
  void operator []=(String key, Map<int, DocData> value) {
    _fields[key] = value;
  }

  Iterable<String> get keys => _fields.keys;
  void clear() => _fields.clear();
  static FieldData empty() {
    return new FieldData(emptyFields());
  }

  static Map<String, Map<int, DocData>> emptyFields() {
    return <String, Map<int, DocData>>{};
  }

  static Map<int, DocData> emptyDocValues() {
    return <int, DocData>{};
  }
}

abstract class IDocSet {
  int length();
  void updateFromString(String docIds);
  void updateFromSet(Set<int> docIds, int length);
  void updateFromDocSet(IDocSet docIds);
  @override
  String toString();
  Iterable<int> toIterable();
  IDocSet and(IDocSet other);
  IDocSet or(IDocSet other);
  IDocSet not(IDocSet other);
  int docCount();

  static IDocSet empty() {
    return new BitDocSet();
    //return new SetDocSet(new Set<int>());
  }

  static IDocSet of(int length) {
    return IDocSet.newDocSetFromSet(new Set<int>(), length);
  }

  static IDocSet newDocSetFromString(String from) {
    final IDocSet r = IDocSet.empty();
    r.updateFromString(from);
    return r;
  }

  static IDocSet newDocSetFromSet(Set<int> from, int length) {
    final IDocSet r = IDocSet.empty();
    r.updateFromSet(from, length);
    return r;
  }

  static IDocSet newDocSetFromDocSet(IDocSet from) {
    final IDocSet r = IDocSet.empty();
    r.updateFromDocSet(from);
    return r;
  }
}

class BitDocSet implements IDocSet {
  BitSet _bs;

  BitDocSet() {
    //no op
  }

  @override
  int length() => (_bs == null) ? 0 : _bs.length;

  @override
  void updateFromString(String docIds) {
    _bs = new BitSet.fromString(docIds);
  }

  @override
  void updateFromSet(Set<int> docIds, int length) {
    _bs = new BitSet(length, false);
    for (int docId in docIds) {
      _bs[docId] = true;
    }
  }

  @override
  void updateFromDocSet(IDocSet docIds) {
    if (docIds is BitDocSet) {
      _bs = docIds.toBitSet();
      return;
    }
    throw new ArgumentError();
  }

  void updateFromBitSet(BitSet docIds) {
    _bs = docIds;
  }

  BitSet toBitSet() {
    return _bs;
  }

  @override
  String toString() {
    return toBitSet().toBinaryString();
  }

  @override
  Iterable<int> toIterable() {
    return (_bs == null) ? new Set<int>() : toBitSet().indices(true);
  }

  @override
  IDocSet and(IDocSet other) {
    if (other is BitDocSet) {
      final BitSet a = _bs.clone().and(other.toBitSet());
      final BitDocSet r = new BitDocSet();
      r.updateFromBitSet(a);
      return r;
    }
    throw new ArgumentError();
  }

  @override
  IDocSet or(IDocSet other) {
    if (other is BitDocSet) {
      final BitSet o = _bs.clone().or(other.toBitSet());
      final BitDocSet r = new BitDocSet();
      r.updateFromBitSet(o);
      return r;
    }
    throw new ArgumentError();
  }

  @override
  IDocSet not(IDocSet other) {
    if (other is BitDocSet) {
      final BitSet n = _bs.clone().andNot(other.toBitSet());
      final BitDocSet r = new BitDocSet();
      r.updateFromBitSet(n);
      return r;
    }
    throw new ArgumentError();
  }

  @override
  int docCount() {
    return (_bs == null) ? 0 : _bs.countBits(true);
  }
}

class SetDocSet implements IDocSet {
  Uint32List _buffer;
  //Uint16List _buffer;
  int _length;

  SetDocSet(Set<int> docIds) {
    updateFromSet(docIds, docIds.length);
  }

  @override
  int length() => _length;

  @override
  void updateFromSet(Set<int> docIds, int length) {
    _buffer = new Uint32List.fromList(docIds.toList());
    //buffer = new Uint16List.fromList(gap(docIds));
    _length = docIds.length;
  }

  @override
  void updateFromString(String docIds) {
    final List<int> ids = getList(docIds);
    _buffer = new Uint32List.fromList(ids);
    _length = ids.length;
  }

  @override
  void updateFromDocSet(IDocSet docIds) {
    if (docIds is SetDocSet) {
      _buffer = docIds.toBuffer();
      _length = docIds.length();
      return;
    }
    throw new ArgumentError();
  }

  Uint32List toBuffer() {
    return _buffer;
  }

  @override
  String toString() {
    return toBuffer().toSet().join(',');
  }

  @override
  Iterable<int> toIterable() {
    return toBuffer().toSet();
  }

  @override
  IDocSet and(IDocSet other) {
    final SetDocSet o = other;
    final Set<int> r = _buffer.toSet().intersection(o.toBuffer().toSet());
    return new SetDocSet(r);
  }

  @override
  IDocSet or(IDocSet other) {
    final SetDocSet o = other;
    final Set<int> r = _buffer.toSet().union(o.toBuffer().toSet());
    return new SetDocSet(r);
  }

  @override
  IDocSet not(IDocSet other) {
    final SetDocSet o = other;
    final Set<int> n = _buffer.toSet().difference(o.toBuffer().toSet());
    return new SetDocSet(n);
  }

  @override
  int docCount() {
    return _length;
  }

  static List<int> getList(String docIds) {
    return docIds.split(',').map((String s) => int.parse(s)).toList();
  }

  static List<int> gap(Set<int> docIds) {
    // expensive operation
    int gap = 0;
    return docIds.map((int docId) {
      final int curNum = docId - gap;
      gap = docId;
      return curNum;
    }).toList();
  }

  static Set<int> ungap(Uint16List buffer) {
    // expensive operation
    int gap = 0;
    return buffer.toList().map((int curNum) {
      final int docId = curNum + gap;
      gap = gap + curNum;
      return docId;
    }).toSet();
  }
}

class DocData {
  Uint8List buffer;
  final Utf8Encoder _encoder = new Utf8Encoder();
  final Utf8Decoder _decoder = new Utf8Decoder();
  DocData(List<String> data) {
    buffer = new Uint8List.fromList(_encoder.convert(data.join('\$')));
  }
  List<String> toList() => _decoder.convert(buffer.toList()).split('\$');
}
