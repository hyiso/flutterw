import 'dart:io';

import 'package:flutterw_clean/flutterw_clean.dart';
import 'package:test/test.dart';

void main() {
  final testEntries = [
    '.testDir/',
    '.testFile'
  ];
  test('funtion clean should work', () {
    Directory testDir = Directory.current.childDirectory(testEntries.first);
    File testFile = Directory.current.childFile(testEntries.last);
    expect(testDir.existsSync(), false);
    expect(testFile.existsSync(), false);
    testDir.createSync(recursive: true);
    testFile.createSync(recursive: true);
    expect(testFile.existsSync(), true);
    stderr.writeln();
    clean(Directory.current, testEntries);
    expect(testDir.existsSync(), false);
    expect(testFile.existsSync(), false);
  });
}
