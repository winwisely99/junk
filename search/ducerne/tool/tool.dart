// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Tool {
  static Future<Null> outJson(String inFilePath, String outFilePath) async {
    final File inFile = new File(inFilePath);
    final List<String> lines = await inFile.readAsLines();
    final File outFile = new File(outFilePath);
    if (!await outFile.exists()) await outFile.create();
    await outFile.writeAsString(JSON.encode(lines),
        mode: FileMode.APPEND, encoding: UTF8);
  }
}

Future<Null> main() async {
  await Tool.outJson("/Users/abe/Desktop/mecab-dict/len/len.csv",
      "/Users/abe/Desktop/mecab-dict/len/noun.json");
}
