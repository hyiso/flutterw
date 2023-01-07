import 'dart:io';

import 'package:args/command_runner.dart';

import '../runner.dart';

class HelpCommand extends Command {
  @override
  String get name => 'help';

  HelpCommand() : super();

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
          final process = await Process.start(
              (runner! as FlutterwRunner).originExecutableName,
              ['help', ...argResults!.rest]);
          return exitCode = await process.exitCode;
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
