import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

abstract class BaseCommand extends Command {

  Future<int> startProcess(
    String executable,
    List<String> arguments,
    {
      String? workingDirectory,
      Map<String, String>? environment,
      bool includeParentEnvironment = true,
      bool runInShell = false,
      ProcessStartMode mode = ProcessStartMode.inheritStdio
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
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      exit(exitCode);
    }
    return exitCode;
  }
}
