import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'command.dart';

mixin WrapperRunner<T> on CommandRunner<T> {

  String get originExecutableName;

  @override
  ArgResults parse(Iterable<String> args) {
    ArgResults results;
    try {
      results = argParser.parse(args);
      if (results.command == null && buildCommand(args) != null) {
        results = super.parse(args);
      }
    } on ArgParserException catch (e) {
      if (e.commands.isEmpty) {
        if (buildCommand(args) != null) {
          results = super.parse(args);
        } else {
          results = ArgParser.allowAnything().parse(args);
        }
      } else {
        rethrow;
      }
    }
    return results;
  }

  Command? buildCommand(Iterable<String> arguments) {
    Command? root;
    Command? parent;
    final args = Queue.of(arguments);
    while (args.isNotEmpty) {
      final name = args.removeFirst();
      if (invalid(name)) {
        break;
      }

      Command<T> command;
      if (args.isEmpty || invalid(args.first)) {
        command = createCommand(name);
      } else {
        command = ParentCommand(name);
      }
      if (parent != null) {
        parent.addSubcommand(command);
      } else {
        addCommand(command);
      }
      parent = command;
      root ??= command;
    }
    return root;
  }

  /// Invalid for command name.
  bool invalid(String name) {
    return name.startsWith('-') || name.contains('.') || name.contains('/');
  }

  Command<T> createCommand(String name) => WrapperCommand<T>(name);

  @override
  Future<T?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults.command == null) {
      if (topLevelResults.rest.isNotEmpty) {
        // No top-level command was chosen.
        runOrigin(topLevelResults.arguments);
        return null;
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