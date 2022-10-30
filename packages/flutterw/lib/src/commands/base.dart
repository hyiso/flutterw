import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:colorize/colorize.dart';
import 'package:flutterw/src/config.dart';

abstract class BaseCommand extends Command {

  Future<int> startProcess(
    String executable,
    List<String> arguments,
    {
      String? workingDirectory,
      Map<String, String>? environment,
      bool includeParentEnvironment = true,
      bool runInShell = false,
      ProcessStartMode mode = ProcessStartMode.inheritStdio,
    }
  ) async {
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode,
    );
    return await process.exitCode;
  }

  Config? get config => Config.lookup(Directory.current);
  
}


abstract class HookableCommand extends BaseCommand {
  @override
  Future<void> run() async {
    var restCommands = argResults!.rest.where((element) => !element.startsWith('-'));
    final preHook = ['pre', name, ...restCommands].join('_');
    final postHook = ['post', name, ...restCommands].join('_');
    await _runHookScripts(preHook);
    final code = await runCommand();
    await _runHookScripts(postHook);
    exit(code);
  }

  Future<void> _runHookScripts(String hook) async {
    Map hooks = config?['hooks'] ?? {};
    if (hooks[hook] != null) {
      stderr.writeln(Colorize('Run $hook hooks').white());
      List hookScripts = hooks[hook];
      for (String script in hookScripts) {
        stderr.writeln(Colorize('[$hook] $script').white());
        final args = script.split(RegExp(r'\s+'));
        final code = await startProcess(
          args.removeAt(0),
          args,
        );
        if (code != 0) {
          exit(code);
        }
      }
    }
  }

  Future<int> runCommand();
}