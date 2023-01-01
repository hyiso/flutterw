import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'arg_wrapper.dart';
import 'runner_wrapper.dart';
import 'utils.dart';

class WrapperCommand<T> extends Command<T> {
  /// hooks map
  /// formatted as:
  /// name:
  ///   - script1
  ///   - script2
  Map<String, List> get hooks => {};

  /// plugins map
  /// formatted as:
  /// name: package
  Map<String, String> get plugins => {};

  @override
  String get description => 'Wraps $name command.';

  @override
  final String name;

  WrapperCommand({
    this.name = '',
  }) : super();

  @override
  final argParser = ArgParser.allowAnything();

  WrapperArgResults get wrapperArgResults =>
      WrapperArgParser().parse([name, ...argResults!.arguments]);

  @override
  FutureOr<T>? run() async {
    await runHook('pre');
    await runCommand();
    await runHook('post');
    return Future.value();
  }

  Future<void> runCommand() async {
    final hittedPluginCommand =
        lookupPluginCommand(plugins, wrapperArgResults.commands);
    if (hittedPluginCommand != null) {
      final plugin = hittedPluginCommand.removeAt(0);
      runPlugin(
        name: plugin,
        package: plugins[plugin]!,
        arguments: [...hittedPluginCommand, ...wrapperArgResults.arguments],
      );
    } else {
      await (runner! as WrapperRunner)
          .runOrigin([name, ...argResults!.arguments]);
    }
  }

  /// Run plugin.
  /// Default use dart pub run.
  /// Exit if exitCode is not 0.
  Future<void> runPlugin({
    required String name,
    required String package,
    List<String> arguments = const [],
  }) async {
    stderr.writeln('Run plugin $name:$package');
    stderr.writeln('  - dart pub run $package ${arguments.join(' ')}');
    final process = await Process.start(
      'dart',
      ['pub', 'run', package, ...arguments],
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
  }

  Future<void> runHook(String type) async {
    if (wrapperArgResults.underlineCommand.isEmpty) {
      return;
    }
    final hook = [type, wrapperArgResults.underlineCommand].join('_');
    if (hooks[hook] != null) {
      printHook(hook);
      List hookScripts = hooks[hook]!;
      for (String script in hookScripts) {
        printHookScript(script);
        final args = script.split(RegExp(r'\s+'));
        final process = await Process.start(
          args.removeAt(0),
          args,
        );
        final code = await process.exitCode;
        if (code != 0) {
          exit(code);
        }
      }
    }
  }

  void printHook(String hook) {
    stderr.writeln('Run $hook hook');
  }

  void printHookScript(String script) {
    stderr.writeln('  - $script');
  }
}
