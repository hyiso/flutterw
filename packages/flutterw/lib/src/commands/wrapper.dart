import 'dart:io';

import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:colorize/colorize.dart';
import 'package:flutterw/runner.dart';
import 'package:flutterw/src/config.dart';

class FlutterWrapperCommand extends WrapperCommand {
  FlutterWrapperCommand({
    required String name,
  }) : super(name: name);

  String get originExecutableName =>
      (runner! as FlutterWrapperRunner).originExecutableName;

  @override
  Map<String, List> get hooks => projectConfig.hooks;

  @override
  Map<String, String> get plugins => projectConfig.plugins;

  @override
  bool get hidden => true;

  bool useGlobalPlugin = false;

  @override
  List<String>? hitPluginCommand() {
    final projectPluginCommand = super.hitPluginCommand();
    if (projectPluginCommand != null) {
      return projectPluginCommand;
    }
    useGlobalPlugin = true;
    return lookupPluginCommand(
        globalConfig.plugins, wrapperArgResults.commands);
  }

  @override
  Future<void> runPlugin(String plugin, List<String> arguments) async {
    stderr.writeln(
        'Hit plugin ${Colorize('$plugin:${plugins[plugin]}')}, run it');
    stderr.writeln(
        '  └> flutter pub run ${plugins[plugin]} ${arguments.join(' ')}');
    final process = await Process.start(
      (runner! as FlutterWrapperRunner).originExecutableName,
      [
        'pub',
        if (useGlobalPlugin) 'global',
        'run',
        plugins[plugin]!,
        ...arguments,
      ],
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
