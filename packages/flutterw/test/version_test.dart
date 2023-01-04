import 'dart:io';

import 'package:flutterw/version.g.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('lib/version.g.dart should be up-to-date.', () {
    final yamlMap =
        loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
    final yamlVersion = yamlMap['version'] as String;
    expect(kPackageVersion, equals(yamlVersion));
  });
}
