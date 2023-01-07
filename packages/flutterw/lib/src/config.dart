import 'dart:io';
import 'package:yaml/yaml.dart';

import 'hook.dart';

class FlutterwConfig {
  FlutterwConfig._(String path) : this.fromFile(File(path));

  FlutterwConfig.fromFile(this.file);

  final File file;

  String? get yaml => file.existsSync() ? file.readAsStringSync() : null;

  YamlMap? get _map {
    if (yaml != null) {
      return loadYaml(yaml!);
    }
    return null;
  }

  Map<String, FlutterwHook> get hooks {
    return (_map?['hooks'] as Map?)
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

FlutterwConfig get projectConfig => FlutterwConfig._('flutterw.yaml');
