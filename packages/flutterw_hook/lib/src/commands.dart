import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:flutterw/flutterw.dart';

import 'config.dart';

abstract class HookCommand extends Command {
  Logger get logger => Logger.standard();

  String get invocationPrefix {
    var parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);
    return parents.reversed.join(' ');
  }

  @override
  String get invocation => '$invocationPrefix <name> [package]';
}

class HookAddCommand extends HookCommand {
  @override
  String get description => 'Add a hook';

  @override
  String get name => 'add';

  @override
  FutureOr? run() async {
    await config.addHook(
        name: argResults!.rest.first, package: argResults!.rest.last);
  }
}

class HookRemoveCommand extends HookCommand {
  @override
  String get description => 'Remove a hook';

  @override
  String get name => 'remove';

  @override
  List<String> get aliases => ['rm'];

  @override
  String get invocation => '$invocationPrefix <name>';

  @override
  FutureOr? run() async {
    await config.removeHook(name: argResults!.rest.first);
  }
}

class HookListCommand extends HookCommand {
  @override
  String get description => 'List all hooks';

  @override
  String get name => 'list';

  @override
  List<String> get aliases => ['ls'];

  @override
  FutureOr? run() async {
    if (projectConfig.hooks.isEmpty) {
      logger.stderr('No hooks.');
      return;
    }
    if (config.hooks.isNotEmpty) {
      logger.stderr('Project Hooks');
      for (var entry in projectConfig.hooks.entries) {
        if (entry.value is String) {
          logger.stderr('  ${entry.key}: ${entry.value}');
        } else if (entry.value is Iterable<String>) {
          logger.stderr('  ${entry.key}: ');
          for (String script in entry.value as Iterable<String>) {
            logger.stderr('    - $script');
          }
        }
      }
    }
  }
}
