import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:flutterw/flutterw.dart';
import 'package:yaml_edit/yaml_edit.dart';

extension WrittableFlutterwConfig on FlutterwConfig {
  Logger get logger => Logger.standard();

  File get file => File('pubspec.yaml');

  Future<void> addHook({
    required String name,
    required String package,
    bool overwrite = false,
  }) async {
    final hook = scripts[name];
    if (hook != null && !overwrite) {
      logger.stderr(
          'Script [$name] has already been set, overwrite it by adding --overwrite flag.');
      return;
    }
    logger.stderr('Set hook [$name] to package [$package].');
    final editor = YamlEditor(await file.readAsString());

    if (scripts.isNotEmpty) {
      editor.update(['scripts', name], package);
    } else {
      editor.update(['scripts'], {name: package});
    }
    file.writeAsStringSync(editor.toString());
  }

  Future<void> removeHook({
    required String name,
  }) async {
    if (scripts[name] == null) {
      logger.stderr(logger.ansi.error('Hook [$name] has not been set.'));
      return;
    }
    logger.stderr('Remove hook [$name].');
    final editor = YamlEditor(file.readAsStringSync());
    if (scripts.keys.length > 1) {
      editor.remove(['scripts', name]);
    } else {
      editor.remove(['scripts']);
    }
    file.writeAsStringSync(editor.toString());
  }
}

FlutterwConfig get config => FlutterwConfig.fromFile(File('pubspec.yaml'));
