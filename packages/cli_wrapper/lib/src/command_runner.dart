import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

mixin WrapperRunner<T> on CommandRunner<T> {

  String get originExecutableName;

  @override
  ArgResults parse(Iterable<String> args) {
    ArgResults results;
    try {
      results = argParser.parse(args);
    } on ArgParserException catch (e) {
      if (e.commands.isEmpty) {
        return ArgParser.allowAnything().parse(args);
      }
      var command = commands[e.commands.first]!;
      for (var commandName in e.commands.skip(1)) {
        command = command.subcommands[commandName]!;
      }

      command.usageException(e.message);
    }
    return results;
  }

  @override
  Future<T?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults.command == null) {
      if (topLevelResults.rest.isNotEmpty) {
        await runOrigin(topLevelResults.arguments);
        return Future.value();
      }
    }
    return super.runCommand(topLevelResults);
  }

  /// Run origin executable command args.
  Future<void> runOrigin(List<String> arguments) async {
    final process = await Process.start(
      originExecutableName,
      arguments,
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
  }

}