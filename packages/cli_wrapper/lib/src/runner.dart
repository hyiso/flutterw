import 'dart:collection';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'command.dart';
import 'hook.dart';

class WrapperRunner<T> extends CommandRunner<T> {
  WrapperRunner(
    String executableName,
    this.originExecutableName, {
    this.hooks = const {},
  }) : super(
          executableName,
          '$executableName wraps $originExecutableName cli with hooks system.',
        );

  final String originExecutableName;

  /// hooks map
  final Map<String, Hook> hooks;

  @override
  ArgResults parse(Iterable<String> args) {
    ArgResults results;
    try {
      results = argParser.parse(args);
      if (results.command == null && _generateCommand(Queue.of(args)) != null) {
        results = super.parse(args);
      }
    } on ArgParserException catch (e) {
      if (e.commands.isEmpty) {
        if (_generateCommand(Queue.of(args)) != null) {
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

  Command? _generateCommand(Queue<String> args) {
    Command? root;
    Command? parent;
    while (args.isNotEmpty) {
      final name = args.removeFirst();
      if (invalidCommand(name)) {
        break;
      }
      final command =
          createCommand(name, args.isEmpty || invalidCommand(args.first));
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

  bool invalidCommand(String name) {
    return name.startsWith('-') || name.startsWith('.') || name.contains('/');
  }

  Command<T> createCommand(String name, [bool isLeaf = true]) {
    return WrapperCommand<T>(name: name, isLeaf: isLeaf);
  }

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
