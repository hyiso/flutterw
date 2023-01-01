import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'arg_wrapper.dart';
import 'command_wrapper.dart';

class WrapperRunner<T> extends CommandRunner<T> {
  WrapperRunner(
    String executableName,
    this.originExecutableName,
  ) : super(
          executableName,
          '$executableName wraps $originExecutableName cli with hooks and plugins system.',
        );

  final String originExecutableName;

  @override
  ArgResults parse(Iterable<String> args) {
    ArgResults results;
    try {
      results = argParser.parse(args);
      if (results.command == null) {
        final wrapResults = WrapperArgParser().parse(args);
        if (wrapResults.commands.isNotEmpty) {
          addWrapperCommand(wrapResults.commands.first);
          results = super.parse(args);
        }
      }
    } on ArgParserException catch (e) {
      if (e.commands.isEmpty) {
        final wrapResults = WrapperArgParser().parse(args);
        if (wrapResults.commands.isNotEmpty) {
          addWrapperCommand(wrapResults.commands.first);
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

  void addWrapperCommand([String name = '']) {
    addCommand(WrapperCommand(name: name));
  }
}
