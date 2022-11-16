import 'dart:io';

import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:colorize/colorize.dart';
import 'package:flutterw/runner.dart';
import 'package:yaml/yaml.dart';

class FlutterWrapperCommand extends WrapperCommand {
  FlutterWrapperCommand({
    required String name,
  }) : super(name: name);

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
  Future<void> runPlugin(String plugin, List<String> arguments) async {
    stderr.writeln(
        'Hit plugin ${Colorize('$plugin:${plugins[plugin]}')}, run it');
    stderr.writeln(
        '  └> flutter pub run ${plugins[plugin]} ${arguments.join(' ')}');
    final process = await Process.start(
      (runner! as FlutterWrapperRunner).originExecutableName,
      ['pub', 'run', plugins[plugin]!, ...arguments],
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
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
