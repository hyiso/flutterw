import 'dart:io';

import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:colorize/colorize.dart';
import 'package:flutterw/runner.dart';
import 'package:yaml/yaml.dart';

class FlutterWrapperCommand extends WrapperCommand {
  FlutterWrapperCommand({
    required super.name,
    required super.originExecutable,
  });

  YamlMap? get config {
    final file = File(kConfigFileName);
    if (file.existsSync()) {
      return loadYaml(file.readAsStringSync());
    }
    return null;
  }

  @override
  Map<String, List> get hooks {
    final Map registeredHooks = config?['hooks'] ?? {};
    return registeredHooks.cast();
  }

  @override
  Map<String, String> get plugins {
    final Map registeredPlugins = config?['plugins'] ?? {};
    return registeredPlugins.cast();
  }

  @override
  bool get hidden => true;

  @override
  void printPlugin(String plugin, List<String> arguments) {
    stderr.writeln(
        'Hit plugin ${Colorize('$plugin:${plugins[plugin]}')}, run it');
    stderr.writeln(
        '  └> $originExecutable pub run ${plugins[plugin]} ${arguments.join(' ')}');
  }

  @override
  void printHook(String hook) {
    stderr.writeln(
        Colorize('Run ${Colorize(hook).white().bold()} hook scripts...')
            .white());
  }

  @override
  void printHookScript(String script) {
    stderr.writeln(Colorize('  └> $script').white());
  }
}
