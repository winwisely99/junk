// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:test/test.dart';

import 'package:ducene/store.dart';

void main() {
  group('A group of directory', () {
    RAMIndexDirectory ramIndexDirectory;
    FSIndexDirectory fsIndexDirectory;
    final Directory dir = new Directory('test-dir');

    setUp(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    test('test init', () async {
      ramIndexDirectory = new RAMIndexDirectory();
      await ramIndexDirectory.initOutput();
      ramIndexDirectory.initInput();
      fsIndexDirectory = new FSIndexDirectory(dir);
      await fsIndexDirectory.initOutput();
      fsIndexDirectory.initInput();

      expect(ramIndexDirectory.inputIndex(), isNotNull);
      expect(fsIndexDirectory.inputIndex(), isNotNull);
      expect(await dir.exists(), isTrue);
    });
  });
}
