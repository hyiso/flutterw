import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class FlutterWrapperConfig {
  final File _file;

  FlutterWrapperConfig._(String path) : _file = File(path);

  String? get _yaml {
    if (_file.existsSync()) {
      return _file.readAsStringSync();
    }
    return null;
  }

  YamlMap? get _map {
    if (_yaml != null) {
      return loadYaml(_yaml!);
    }
    return null;
  }

  Map<String, dynamic> get hooks {
    final Map registeredHooks = _map?['hooks'] ?? {};
    return registeredHooks.cast();
  }

  Future<void> addHook({
    required String name,
    required String package,
  }) async {
    if (hooks[name] != null) {
      Logger.standard()
          .stderr('Hook [$name] was set to package [${hooks[name]}].');
      Logger.standard().stderr('This will overwrite it to pacjage [$package].');
      return;
    } else {
      Logger.standard().stderr('Set hook [$name] to package [$package].');
    }
    final hooksMap = {
      ...hooks,
      name: package,
    };

    final editor = YamlEditor(_yaml ?? '');
    if (hooks.isNotEmpty) {
      editor.update(['hooks'], hooksMap);
    } else {
      editor.update([], {'hooks': hooksMap});
    }
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
    }
    _file.writeAsStringSync(editor.toString());
  }

  Future<void> removeHook({
    required String name,
  }) async {
    if (hooks[name] == null) {
      Logger.standard().stderr(
          Logger.standard().ansi.error('Hook [$name] has not been set.'));
      return;
    }
    Logger.standard().stderr('Remove hook [$name].');
    final hooksMap = {...hooks};
    hooksMap.remove(name);
    final editor = YamlEditor(_yaml ?? '');
    editor.update(['hooks'], hooksMap.isEmpty ? null : hooksMap);
    _file.writeAsStringSync(editor.toString());
  }
}

FlutterWrapperConfig get globalConfig => FlutterWrapperConfig._(
    join(Platform.environment['HOME']!, '.flutterw.yaml'));

FlutterWrapperConfig get projectConfig =>
    FlutterWrapperConfig._('flutterw.yaml');
