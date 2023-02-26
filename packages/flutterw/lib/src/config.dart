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

  Map<String, List<String>> get scripts {
    final scriptsNode = yaml?['scripts'];
    if (scriptsNode == null) {
      return {};
    }
    if (scriptsNode is! Map) {
      throw FormatException('scripts in pubspec.yaml should be a Map');
    }
    final scriptsMap = <String, List<String>>{};
    for (var name in scriptsNode.keys) {
      final value = scriptsNode[name];
      if (value is List) {
        scriptsMap[name] = value.map((e) => e.toString().trim()).toList();
      } else if (value is String) {
        scriptsMap[name] = value.split('&&').map((e) => e.trim()).toList();
      } else {
        throw FormatException(
            'Value of script $name can only be String or List<String>');
      }
    }
    return scriptsMap;
  }
}
