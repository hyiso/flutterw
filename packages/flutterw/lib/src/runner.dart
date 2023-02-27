import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:tuple/tuple.dart';

import 'commands/help.dart';
import 'exception.dart';
import 'logger.dart';
import 'search.dart';
import 'shell.dart';
import 'version.g.dart';

/// A class that can run Flutterw with scripts and command hooks system support.
///
/// To run a command, do:
///
/// ```dart main
/// final flutterw = FlutterwRunner();
///
/// await flutterw.run(['pub', 'get']);
/// ```
class FlutterwRunner extends CommandRunner {
  FlutterwRunner({
    this.scripts = const {},
    this.runOrigin = runFlutter,
    this.logger,
  }) : super('flutterw',
            'flutterw wraps flutter with scripts and command hooks support');

  final Map<String, List<String>> scripts;

  /// Logger
  final Logger? logger;

  ///
  final Future<int> Function(List<String>) runOrigin;

  @override
  String? get usageFooter =>
      '\nAnd use flutterw as flutter with scripts and command hooks support:\n'
      '  flutterw doctor\n'
      '  flutterw clean\n'
      '  flutterw pub get\n'
      '  ...';

  @override
  void addCommand(Command command) {
    if (command.name == 'help') {
      super.addCommand(HelpCommand());
    } else {
      super.addCommand(command);
    }
  }

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
  Future run(Iterable<String> args) async {
    // No arguments or contains -h,--help
    if (args.isEmpty || args.contains('-h') || args.contains('--help')) {
      return super.run(args);
    }
    final topLevelResults = parse(args);
    final commandHooks = searchCommandHooks(args: args, scripts: scripts);
    final pre = commandHooks.item1;
    if (pre != null) {
      await _hook(pre);
    }
    final command = commandHooks.item2;
    dynamic result;
    if (command != null) {
      result = await _hook(command);
    } else {
      result = await runCommand(topLevelResults);
    }
    final post = commandHooks.item3;
    if (post != null) {
      await _hook(post);
    }
    return result;
  }

  @override
  Future<dynamic> runCommand(ArgResults topLevelResults) {
    if (topLevelResults.command == null && topLevelResults.rest.isNotEmpty) {
      if (topLevelResults.rest.contains('--version')) {
        stdout.writeln('Flutterw $kFlutterwVersion');
      }
      return Future.sync(() => runOrigin(topLevelResults.arguments));
    }
    return super.runCommand(topLevelResults);
  }

  /// Run hook defined in [scripts]
  Future<int> _hook(Tuple2<String, List<String>> hook) async {
    logger?.script(hook.item1, scripts[hook.item1]);
    final code =
        await runShells(scripts[hook.item1]!, hook.item2, logger: logger);
    if (code != 0) {
      throw ScriptException(hook.item1);
    }
    return 0;
  }
}
