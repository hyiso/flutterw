import 'dart:io';

import 'package:flutterw_clean/flutterw_clean.dart';
import 'package:path/path.dart';

const _kCleanableEntries = [
  'build/',
  '.dart_tool/',
  '.android/',
  '.ios/',
  '.flutter-plugins',
  '.flutter-plugins-dependencies',
  '.packages',
];

void main(List<String> arguments) {
  stderr.writeln('Running "flutterw clean" in ${basename(Directory.current.path)}...');
  clean(Directory.current, _kCleanableEntries);
}
