import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutterw/src/config.dart';

class HookCommand extends Command {
  @override
  String get description => 'Manage Flutterw Hooks.';

  @override
  String get name => 'hook';

  HookCommand() {
    addSubcommand(HookAddCommand());
    addSubcommand(HookRemoveCommand());
    addSubcommand(HookListCommand());
  }
}

class HookAddCommand extends Command {
  @override
  String get description => 'Add a hook';

  @override
  String get name => 'add';

  @override
  String get invocation {
    var parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    var invocation = parents.reversed.join(' ');
    return '$invocation <name> <package> [--global,-g]';
  }

  HookAddCommand() {
    argParser.addFlag('global',
        abbr: 'g', negatable: false, help: 'Add a hook globally.');
  }

  @override
  FutureOr? run() async {
    final isGlobal = argResults!['global'] == true;
    final config = isGlobal ? globalConfig : projectConfig;
    await config.addHook(
        name: argResults!.rest.first, package: argResults!.rest.last);
  }
}

class HookRemoveCommand extends Command {
  @override
  String get description => 'Remove a hook';

  @override
  String get name => 'remove';

  @override
  List<String> get aliases => ['rm'];

  @override
  String get invocation {
    var parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    var invocation = parents.reversed.join(' ');
    return '$invocation <name> [--global,-g]';
  }

  HookRemoveCommand() {
    argParser.addFlag('global',
        abbr: 'g', negatable: false, help: 'Remove a hook globally.');
  }

  @override
  FutureOr? run() async {
    final isGlobal = argResults!['global'] == true;
    final config = isGlobal ? globalConfig : projectConfig;
    await config.removeHook(name: argResults!.rest.first);
  }
}

class HookListCommand extends Command {
  @override
  String get description => 'List all hooks';

  @override
  String get name => 'list';

  @override
  List<String> get aliases => ['ls'];

  @override
  FutureOr? run() async {
    if (projectConfig.hooks.isEmpty && globalConfig.hooks.isEmpty) {
      stderr.writeln('No hooks.');
      return;
    }
    if (globalConfig.hooks.isNotEmpty) {
      stderr.writeln('Global Hooks');
      for (var entry in globalConfig.hooks.entries) {
        stderr.writeln('  ${entry.key}: ${entry.value}');
      }
    }
    if (projectConfig.hooks.isNotEmpty) {
      stderr.writeln('Project Hooks');
      for (var entry in projectConfig.hooks.entries) {
        stderr.writeln('  ${entry.key}: ${entry.value}');
      }
    }
  }
}
