import 'dart:io';

import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:flutterw/runner.dart';
import 'package:flutterw/src/config.dart';
import 'package:flutterw/src/logger.dart';

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
  Future<void> runCommand() async {
    var hittedPluginCommand =
        lookupPluginCommand(plugins, wrapperArgResults.commands);
    if (hittedPluginCommand == null) {
      useGlobalPlugin = true;
      hittedPluginCommand =
          lookupPluginCommand(globalConfig.plugins, wrapperArgResults.commands);
    }
    if (hittedPluginCommand != null) {
      final name = hittedPluginCommand.removeAt(0);
      final package = useGlobalPlugin
          ? globalConfig.plugins[name]
          : projectConfig.plugins[name];
      runPlugin(
        name: name,
        package: package!,
        arguments: [...hittedPluginCommand, ...wrapperArgResults.arguments],
      );
    } else {
      await (runner! as FlutterWrapperRunner)
          .runOrigin([name, ...argResults!.arguments]);
    }
  }

  @override
  Future<void> runPlugin({
    required String name,
    required String package,
    List<String> arguments = const [],
  }) async {
    stderr.writeln(
        'Redirect to plugin ${logger.ansi.emphasized('$name:$package')}');
    final exe = (runner! as FlutterWrapperRunner).originExecutableName;
    final args = [
      'pub',
      if (useGlobalPlugin) 'global',
      'run',
      package,
      ...arguments.takeWhile((value) => !['-v', '--verbose'].contains(value)),
    ];
    final progress = logger.progress('  └> $exe ${args.join(' ')}');
    final process = await Process.start(exe, args,
        mode: logger.isVerbose
            ? ProcessStartMode.inheritStdio
            : ProcessStartMode.normal);
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
    progress.finish(showTiming: true);
  }

  @override
  void printHook(String hook) {
    stderr.writeln('Run ${logger.ansi.emphasized(hook)} hook scripts...');
  }

  @override
  void printHookScript(String script) {
    stderr.writeln(logger.ansi.emphasized('  └> $script'));
  }
}
