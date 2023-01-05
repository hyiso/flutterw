// @dart=2.9

import 'dart:io' show File;
import 'package:path/path.dart' show join;
import 'package:yaml/yaml.dart' show YamlMap, loadYaml;

Future<void> main() async {
  final outputPath = join('lib', 'src', 'version.g.dart');
  // ignore: avoid_print
  print('Updating generated file $outputPath');
  final yamlMap = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
  final currentVersion = yamlMap['version'] as String;
  final fileContents = '''
/// This file is generated. Do not manually edit.
const kPackageVersion = '$currentVersion';
''';
  await File(outputPath).writeAsString(fileContents);
  // ignore: avoid_print
  print('Updated version to $currentVersion in generated file $outputPath');
}
