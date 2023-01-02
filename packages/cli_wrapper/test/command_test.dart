import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:test/test.dart';

Command? _getLeafCommand(ArgResults topLevelResults, CommandRunner runner) {
  ArgResults argResults = topLevelResults;
  Command? command;
  var commands = runner.commands;
  while (commands.isNotEmpty) {
    // Step into the command.
    argResults = argResults.command!;
    command = commands[argResults.name]!;
    commands = command.subcommands;
  }
  return command;
}

class _TestHook extends Hook {
  @override
  final String name;

  _TestHook(this.name);

  @override
  List<String> get scripts => [];

}

void main() {
  final prefix = 'pre_';
  final args = ['foo', 'bar', '--flag', '-h'];

  final rootHook = _TestHook('pre_foo');
  final leafHook = _TestHook('pre_foo_bar');

  group('WrapperCommand.lookupHook should work', (() {

    test('without hooks', () {
      final runner = WrapperRunner('cliw', 'cli');
      final argResults = runner.parse(args);
      final command = _getLeafCommand(argResults, runner) as WrapperCommand;
      expect(command.commandList, equals(['foo', 'bar']));
      expect(command.lookupHook(prefix), equals(null));
    });

    test('when only root hook exists', () {
      final runner = WrapperRunner(
        'cliw', 'cli', 
        hooks: {rootHook.name: rootHook});
      final argResults = runner.parse(args);
      final command = _getLeafCommand(argResults, runner) as WrapperCommand;
      final pre = command.lookupHook(prefix);
      expect(pre != null, true);
      expect(pre!.item1, equals(rootHook));
      expect(pre.item2, equals(['bar']));
    });

    test('when only leaf hook exists', () {
      final runner = WrapperRunner(
        'cliw', 'cli',
        hooks: {leafHook.name: leafHook});
      final argResults = runner.parse(args);
      final command = _getLeafCommand(argResults, runner) as WrapperCommand;
      final pre = command.lookupHook(prefix);
      expect(pre != null, true);
      expect(pre!.item1, equals(leafHook));
      expect(pre.item2, equals([]));
    });

    test('when both leaf and root hook exist', () {
      final runner = WrapperRunner(
        'cliw', 'cli',
        hooks: {
          rootHook.name: rootHook,
          leafHook.name: leafHook,
        });
      final argResults = runner.parse(args);
      final command = _getLeafCommand(argResults, runner) as WrapperCommand;
      final pre = command.lookupHook(prefix);
      expect(pre != null, true);
      expect(pre!.item1, equals(leafHook));
      expect(pre.item2, equals([]));
    });
  }));
}
