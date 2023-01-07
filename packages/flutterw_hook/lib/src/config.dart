import 'package:cli_util/cli_logging.dart';
import 'package:flutterw/flutterw.dart';
import 'package:yaml_edit/yaml_edit.dart';

class FlutterwHookConfig extends FlutterwConfig {
  FlutterwHookConfig.fromFile(super.file) : super.fromFile();

  Logger get logger => Logger.standard();

  Future<void> addHook({
    required String name,
    required String package,
  }) async {
    final hook = hooks[name];
    if (hook != null && hook.package.isNotEmpty) {
      logger.stderr('Hook [$name] was set to package [${hook.package}].');
      logger.stderr('This will overwrite it to pacjage [$package].');
      return;
    } else {
      logger.stderr('Set hook [$name] to package [$package].');
    }
    final hooksMap = {
      ...hooks,
      name: package,
    };

    final editor = YamlEditor(yaml ?? '');
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
    final editor = YamlEditor(yaml ?? '');
    editor.update(['hooks'], hooksMap.isEmpty ? null : hooksMap);
    file.writeAsStringSync(editor.toString());
  }
}

FlutterwHookConfig get config =>
    FlutterwHookConfig.fromFile(projectConfig.file);
