import 'dart:io';

import 'package:yaml/yaml.dart';

class FlutterWrapperConfig {
  FlutterWrapperConfig._(String path) : this.fromFile(File(path));

  FlutterWrapperConfig.fromFile(this.file);

  final File file;

  String? get yaml => file.existsSync() ? file.readAsStringSync() : null;

  YamlMap? get _map {
    if (yaml != null) {
      return loadYaml(yaml!);
    }
    return null;
  }

  Map<String, dynamic> get hooks {
    final Map registeredHooks = _map?['hooks'] ?? {};
    return registeredHooks.cast();
  }
}

FlutterWrapperConfig get projectConfig =>
    FlutterWrapperConfig._('flutterw.yaml');
