// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lzma/lzma.dart' as lzma;

import '../../../src/index/index_reader.dart';
import '../../../src/store/index_directory.dart';

/// A file system based [IndexDirectory] implementation.
class FSIndexDirectory implements IndexDirectory {
  final Directory _dir;
  FSIndexDirectory(this._dir);
  Directory get dir => _dir;

  @override
  Future<Null> initOutput() async {
    if (await _dir.exists()) await _dir.delete(recursive: true);
    if (!await _dir.exists()) await _dir.create(recursive: true);
  }

  @override
  Future<Null> outputIndexInfo(IndexInfo info) async {
    final File indexInfoFile = new File('${_dir.path}/.ii');
    if (!await indexInfoFile.exists()) await indexInfoFile.create();
    await indexInfoFile.writeAsString(info.toString(),
        mode: FileMode.APPEND, encoding: UTF8);
  }

  @override
  Future<Null> outputLiveDocs(IDocSet docIds) async {
    final File liveDocsFile = new File('${_dir.path}/.liv');
    if (await liveDocsFile.exists()) await liveDocsFile.delete(); //mutable
    if (!await liveDocsFile.exists()) await liveDocsFile.create();
    await liveDocsFile.writeAsString(docIds.toString(),
        mode: FileMode.APPEND, encoding: UTF8);
  }

  @override
  Future<Null> outputIndex(String name, Map<String, IDocSet> index) async {
    final File indexFile = new File('${_dir.path}/$name.idx');
    if (!await indexFile.exists()) await indexFile.create();
    for (String key in index.keys) {
      final String value = Compressor.getDefault().comp(index[key].toString());
      final String line = '$key=>$value';
      await indexFile.writeAsString(line + '\n',
          mode: FileMode.APPEND, encoding: UTF8);
    }
  }

  @override
  Future<Null> outputData(String name, Map<int, DocData> data) async {
    final File storeFile = new File('${_dir.path}/$name.data');
    if (!await storeFile.exists()) await storeFile.create();
    for (int key in data.keys) {
      final String value = data[key].toList().join('\$');
      final String line = '${key.toString()}=>$value';
      await storeFile.writeAsString(line + '\n',
          mode: FileMode.APPEND, encoding: UTF8);
    }
  }

  @override
  void initInput() {}

  @override
  IndexInfoSource inputIndexInfo() =>
      new IndexInfoSource(new FSIndexInfoStreams(_dir));

  @override
  LiveDocsSource inputLiveDocs() =>
      new LiveDocsSource(new FSLiveDocsStreams(_dir));

  @override
  IndexSource inputIndex() => new IndexSource(new FSIndexStreams(_dir));

  @override
  DataSource inputData() => new DataSource(new FSDataStreams(_dir));
}

class FSIndexInfoStreams extends IndexInfoStreams {
  final Directory _dir;
  FSIndexInfoStreams(this._dir);
  @override
  Future<Null> readFully(IndexInfo to) async {
    for (String path in await FSIndexUtils.getFileList(_dir, '.ii')) {
      final File file = new File(path);
      final String s = await file.readAsString();
      if (s.length > 0) {
        to.updateFromMap(IndexInfo.getMap(s));
      }
      break;
    }
  }
}

class FSLiveDocsStreams extends LiveDocsStreams {
  final Directory _dir;
  FSLiveDocsStreams(this._dir);
  @override
  Future<Null> readFully(IDocSet to) async {
    for (String path in await FSIndexUtils.getFileList(_dir, '.liv')) {
      final File file = new File(path);
      final String s = await file.readAsString();
      if (s.length > 0) {
        to.updateFromString(s);
      }
      break;
    }
  }
}

class FSIndexStreams extends IndexStreams {
  final Directory _dir;
  FSIndexStreams(this._dir);
  bool _readFully = false;
  @override
  Future<Null> readFully(Index to) async {
    for (String path in await FSIndexUtils.getFileList(_dir, '.idx')) {
      final String name = FSIndexUtils.getName(path, '.idx');
      final File indexFile = new File(path);
      final List<String> lines = await indexFile.readAsLines();
      final Map<String, IDocSet> termDict = Index.emptyTermDictionary();
      for (String line in lines) {
        final List<String> kv = line.split('=>');
        termDict[kv[0]] =
            IDocSet.newDocSetFromString(Compressor.getDefault().decomp(kv[1]));
      }
      to[name] = termDict;
    }
    _readFully = true;
  }

  @override
  Future<Null> readTerms(String field, Index to) async {
    if (!_readFully) await readFully(to);
  }

  @override
  Future<Null> readPostings(String field, String term, Index to) async {
    if (!_readFully) await readFully(to);
  }
}

class FSDataStreams extends DataStreams {
  final Directory _dir;
  FSDataStreams(this._dir);
  bool _readFully = false;
  @override
  Future<Null> readFully(FieldData to) async {
    for (String path in await FSIndexUtils.getFileList(_dir, '.data')) {
      final String name = FSIndexUtils.getName(path, '.data');
      final File dataFile = new File(path);
      final String str = await dataFile.readAsString();
      final List<String> lines = str.split('\n');
      final Map<int, DocData> docValues = FieldData.emptyDocValues();
      for (String line in lines) {
        final List<String> kv = line.split('=>');
        if (kv.length == 2) {
          docValues[int.parse(kv[0])] = new DocData(kv[1].split('\$'));
        }
      }
      to[name] = docValues;
    }
    _readFully = true;
  }

  @override
  Future<Null> readFields(FieldData to) async {
    if (!_readFully) await readFully(to);
  }

  @override
  Future<Null> readValues(String field, int docId, FieldData to) async {
    if (!_readFully) await readFully(to);
  }
}

class FSIndexUtils {
  static Future<List<String>> getFileList(
      Directory dir, String extension) async {
    final List<String> list = await dir
        .list(recursive: false, followLinks: false)
        .map((FileSystemEntity e) => e.path)
        .where((String path) => path.endsWith(extension))
        .toList();
    list.sort();
    return list;
  }

  static String getName(String path, String extension) =>
      path.split('/').last.replaceAll(extension, '');
}

abstract class Compressor {
  String comp(String x);
  String decomp(String x);
  static Compressor getDefault() => new NoOpCompressor();
}

class NoOpCompressor implements Compressor {
  @override
  String comp(String x) => x;
  @override
  String decomp(String x) => x;
}

// slow
class LZMACompressor implements Compressor {
  static final Base64Encoder _base64Encoder = new Base64Encoder();
  static final Base64Decoder _base64Decoder = new Base64Decoder();
  @override
  String comp(String x) {
    final lzma.InStream input = new lzma.InStream(ASCII.encode(x));
    final lzma.OutStream out = new lzma.OutStream();
    lzma.compress(input, out);
    return _base64Encoder.convert(out.data);
  }

  @override
  String decomp(String x) {
    final lzma.InStream input = new lzma.InStream(_base64Decoder.convert(x));
    final lzma.OutStream out = new lzma.OutStream();
    lzma.decompress(input, out);
    return ASCII.decode(out.data);
  }
}

class FSIndexJsonConverter {
  final Directory _dir;
  FSIndexDirectory _fsDir;

  FSIndexJsonConverter(this._dir) {
    _fsDir = new FSIndexDirectory(_dir);
  }

  Future<Null> run() async {
    final Map<String, Object> ret = <String, Object>{};

    final IndexInfo info = IndexInfo.empty();
    await _fsDir.inputIndexInfo().read(info);

    final IDocSet docSet = IDocSet.empty();
    await _fsDir.inputLiveDocs().read(docSet);
    //final String liveDocs = docSet.toString();
    final Set<int> docIds = docSet.toIterable().toSet();
    final SetDocSet setDocSet = new SetDocSet(docIds);
    final String liveDocs = setDocSet.toString();

    final Index inputIndex = Index.empty();
    await _fsDir.inputIndex().read(inputIndex);
    final Map<String, Map<String, Map<String, String>>> idx =
        <String, Map<String, Map<String, String>>>{};
    for (String fieldName in inputIndex.keys) {
      final Map<String, IDocSet> fieldValue = inputIndex[fieldName];
      final Map<String, Map<String, String>> terms =
          <String, Map<String, String>>{};
      int i = 0;
      for (String term in fieldValue.keys) {
        final Map<String, String> termInfo = <String, String>{};
        //final String postings = fieldValue[term].toString();
        //termInfo["postings"] = postings;
        final Set<int> docIds = fieldValue[term].toIterable().toSet();
        final SetDocSet setDocSet = new SetDocSet(docIds);
        termInfo["postings"] = setDocSet.toString();
        termInfo["term"] = term;
        terms[i.toString()] = termInfo;
        i++;
      }
      idx[fieldName] = terms;
    }

    final FieldData inputData = FieldData.empty();
    await _fsDir.inputData().read(inputData);
    final Map<String, Map<String, String>> data =
        <String, Map<String, String>>{};
    for (String fieldName in inputData.keys) {
      final Map<int, DocData> fieldValue = inputData[fieldName];
      final Map<String, String> fieldData = <String, String>{};
      for (int docId in fieldValue.keys) {
        final List<String> data = fieldValue[docId].toList();
        fieldData[docId.toString()] = data.join("\$");
      }
      data[fieldName] = fieldData;
    }

    ret["info"] = info.toString();
    ret["idx"] = idx;
    ret["data"] = data;
    ret["liv"] = liveDocs;

    await _outJson(ret, "fsindex.json");
  }

  Future<Null> _outJson(Map<String, Object> obj, String outFilePath) async {
    final File outFile = new File(outFilePath);
    if (await outFile.exists()) await outFile.delete();
    if (!await outFile.exists()) await outFile.create();
    await outFile.writeAsString(JSON.encode(obj),
        mode: FileMode.APPEND, encoding: UTF8);
  }
}
