import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutterw/src/config.dart';

class PluginCommand extends Command {
  @override
  String get description => 'Manage Flutterw Plugins.';

  @override
  String get name => 'plugin';

  PluginCommand() {
    addSubcommand(PluginAddCommand());
    addSubcommand(PluginRemoveCommand());
  }
}

class PluginAddCommand extends Command {
  @override
  String get description => 'Add a plugin';

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

  PluginAddCommand() {
    argParser.addFlag('global',
        abbr: 'g', negatable: false, help: 'Add a plugin globally.');
  }

  @override
  FutureOr? run() async {
    final isGlobal = argResults!['global'] == true;
    final config = isGlobal ? globalConfig : projectConfig;
    await config.addPlugin(
        name: argResults!.rest.first, package: argResults!.rest.last);
  }
}

class PluginRemoveCommand extends Command {
  @override
  String get description => 'Remove a plugin';

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

  PluginRemoveCommand() {
    argParser.addFlag('global',
        abbr: 'g', negatable: false, help: 'Remove a plugin globally.');
  }

  @override
  FutureOr? run() async {
    final isGlobal = argResults!['global'] == true;
    final config = isGlobal ? globalConfig : projectConfig;
    await config.removePlugin(name: argResults!.rest.first);
  }
}
