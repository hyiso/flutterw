import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class FlutterwHookConfig {
  FlutterwHookConfig.fromFile(this.file);

  final File file;

  Logger get logger => Logger.standard();

  Map<String, dynamic> get hooks {
    if (!file.existsSync()) {
      return {};
    }
    final YamlMap? yaml = loadYaml(file.readAsStringSync());
    return (yaml?['hooks'] as Map? ?? {}).cast();
  }

  Future<void> addHook({
    required String name,
    required String package,
    bool overwrite = false,
  }) async {
    final hook = hooks[name];
    if (hook != null && !overwrite) {
      logger.stderr(
          'Hook [$name] has already been set, overwrite it by adding --overwrite flag.');
      return;
    }
    logger.stderr('Set hook [$name] to package [$package].');
    if (!file.existsSync()) {
      file.writeAsStringSync('''
hooks:
  $name: $package''');
      return;
    }
    final editor = YamlEditor(file.readAsStringSync());
    final hooksMap = {
      ...hooks,
      name: package,
    };

    if (hooks.isNotEmpty) {
      editor.update(['hooks'], hooksMap);
    } else {
      editor.update([], {'hooks': hooksMap});
    }
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(editor.toString());
  }

  Future<void> removeHook({
    required String name,
  }) async {
    if (hooks[name] == null) {
      logger.stderr(logger.ansi.error('Hook [$name] has not been set.'));
      return;
    }
    logger.stderr('Remove hook [$name].');
    final hooksMap = {...hooks};
    hooksMap.remove(name);
    final editor = YamlEditor(file.readAsStringSync());
    editor.update(['hooks'], hooksMap.isEmpty ? null : hooksMap);
    file.writeAsStringSync(editor.toString());
  }
}

FlutterwHookConfig get config =>
    FlutterwHookConfig.fromFile(File('flutterw.yaml'));
