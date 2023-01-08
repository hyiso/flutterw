import 'dart:io';
import 'package:yaml/yaml.dart';

import 'hook.dart';

class FlutterwConfig {
  FlutterwConfig.empty() : yaml = null;

  FlutterwConfig.fromFile(File file) : yaml = loadYaml(file.readAsStringSync());

  FlutterwConfig.fromYaml(String content) : yaml = loadYaml(content);

  final YamlMap? yaml;

  Map<String, FlutterwHook> get hooks {
    return (yaml?['hooks'] as Map?)
            ?.cast<String, dynamic>()
            .map<String, FlutterwHook>((key, value) {
          if (value is List) {
            return MapEntry(
                key,
                FlutterwHook.fromScripts(
                  name: key,
                  scripts: value.cast(),
                ));
          } else {
            return MapEntry(
                key,
                FlutterwHook.fromPackage(
                  name: key,
                  package: value as String,
                ));
          }
        }) ??
        {};
  }
}
