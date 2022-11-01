import 'dart:io';

import 'package:flutterw_clean/flutterw_clean.dart';

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
  clean(Directory.current, _kCleanableEntries);
}
