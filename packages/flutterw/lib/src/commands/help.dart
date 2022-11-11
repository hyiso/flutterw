import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';

class HelpCommand extends WrapperCommand {
  @override
  String get name => 'help';

  HelpCommand({required super.originExecutable});

  @override
  String get description =>
      'Display help information for ${runner!.executableName}.';

  @override
  String get invocation => '${runner!.executableName} help [command]';

  @override
  bool get hidden => true;

  @override
  Future run() async {
    // Show the default help if no command was specified.
    if (argResults!.rest.isEmpty) {
      runner!.printUsage();
      return;
    }

    // Walk the command tree to show help for the selected command or
    // subcommand.
    var commands = runner!.commands;
    Command? command;
    var commandString = runner!.executableName;

    for (var name in argResults!.rest) {
      if (commands.isEmpty) {
        command!.usageException(
            'Command "$commandString" does not expect a subcommand.');
      }

      if (commands[name] == null) {
        if (command == null) {
          final process =
              Process.runSync(originExecutable, ['help', ...argResults!.rest]);
          stderr.write((process.stderr as String?)
              ?.replaceAll('$originExecutable ', '${runner!.executableName} '));
          stdout.write((process.stdout as String?)
              ?.replaceAll('$originExecutable ', '${runner!.executableName} '));
          return;
        }

        command.usageException(
            'Could not find a subcommand named "$name" for "$commandString".');
      }

      command = commands[name];
      commands = command!.subcommands;
      commandString += ' $name';
    }

    command!.printUsage();
  }
}
