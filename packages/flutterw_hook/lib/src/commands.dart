import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';

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
}

class HookAddCommand extends HookCommand {
  @override
  String get description => 'Add a hook';

  @override
  String get name => 'add';

  @override
  String get invocation => '$invocationPrefix <name> [package]';

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
  String get description => 'List all scripts';

  @override
  String get name => 'list';

  @override
  List<String> get aliases => ['ls'];

  @override
  FutureOr? run() async {
    if (config.scripts.isEmpty) {
      logger.stderr('No scripts.');
      return;
    }
    if (config.scripts.isNotEmpty) {
      logger.stderr('Project Scripts');
      for (var entry in config.scripts.entries) {
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
