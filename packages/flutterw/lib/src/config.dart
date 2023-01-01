import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

const kConfigFileName = 'flutterw.yaml';

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

  Map<String, List> get hooks {
    final Map registeredHooks = _map?['hooks'] ?? {};
    return registeredHooks.cast();
  }

  Map<String, String> get plugins {
    final Map registeredPlugins = _map?['plugins'] ?? {};
    return registeredPlugins.cast();
  }

  Future<void> addPlugin({
    required String name,
    required String package,
  }) async {
    if (plugins[name] != null) {
      Logger.standard()
          .stderr('Plugin [$name] was set to package [${plugins[name]}].');
      Logger.standard().stderr('This will overwrite it to pacjage [$package].');
      return;
    } else {
      Logger.standard().stderr('Set plugin [$name] to package [$package].');
    }
    final pluginsMap = {
      ...plugins,
      name: package,
    };

    final editor = YamlEditor(_yaml ?? '');
    if (plugins.isNotEmpty) {
      editor.update(['plugins'], pluginsMap);
    } else {
      editor.update([], {'plugins': pluginsMap});
    }
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
    }
    _file.writeAsStringSync(editor.toString());
  }

  Future<void> removePlugin({
    required String name,
  }) async {
    if (plugins[name] == null) {
      Logger.standard().stderr(
          Logger.standard().ansi.error('Plugin [$name] has not been set.'));
      return;
    }
    Logger.standard().stderr('Remove plugin [$name].');
    final pluginsMap = {...plugins};
    pluginsMap.remove(name);
    final editor = YamlEditor(_yaml ?? '');
    editor.update(['plugins'], pluginsMap.isEmpty ? null : pluginsMap);
    _file.writeAsStringSync(editor.toString());
  }
}

FlutterWrapperConfig get globalConfig => FlutterWrapperConfig._(
    join(Platform.environment['HOME']!, '.flutterw', kConfigFileName));

FlutterWrapperConfig get projectConfig =>
    FlutterWrapperConfig._(kConfigFileName);
