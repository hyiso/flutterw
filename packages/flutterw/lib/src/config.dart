import 'dart:io';
import 'package:yaml/yaml.dart';

/// FlutterwConfig
///
/// contains a [scripts] map
class FlutterwConfig {
  FlutterwConfig.empty() : yaml = null;

  FlutterwConfig.fromFile(File file) : yaml = loadYaml(file.readAsStringSync());

  FlutterwConfig.fromYaml(String content) : yaml = loadYaml(content);

  final YamlMap? yaml;

  Map<String, dynamic> get scripts {
    return (yaml?['scripts'] as Map?)?.cast<String, dynamic>() ?? {};
  }
}
