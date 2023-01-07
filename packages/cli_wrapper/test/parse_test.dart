import 'package:args/args.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('WrapperRunner.parse should work when', (() {

    final runner = TestRunner();
    test('args is empty.', () {
      final ArgResults argResults = runner.parse([]);
      expect(argResults.name == null, true);
      expect(argResults.arguments.isEmpty, true);
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, true);
    });
    test('args is -h flag.', () {
      final ArgResults argResults = runner.parse(['-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, true);
    });
    test('args is unsupported flag.', () {
      final ArgResults argResults = runner.parse(['--version']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['--version']));
      expect(argResults.rest, equals(['--version']));
      expect(argResults.command == null, true);
    });
  }));

  group('WrapperRunner.parse should work when args is unsupported command', (() {
    final runner = TestRunner();
    test('', () {
      final ArgResults argResults = runner.parse(['test']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test']));
      expect(argResults.rest.isEmpty, false);
      expect(argResults.command == null, true);
    });

    test('with -h flag.', () {
      final ArgResults argResults = runner.parse(['test', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', '-h']));
      expect(argResults.rest, equals(['test']));
      expect(argResults.command == null, true);
    });

    test('with unsupported flag.', () {
      final ArgResults argResults = runner.parse(['test', '-v']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', '-v']));
      expect(argResults.rest, equals(['test', '-v']));
      expect(argResults.command == null, true);
    });

    test('with subcommand.', () {
      final ArgResults argResults = runner.parse(['test', 'sub']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', 'sub']));
      expect(argResults.rest, equals(['test', 'sub']));
      expect(argResults.command == null, true);
    });

    test('with subcommand and -h flag.', () {
      final ArgResults argResults = runner.parse(['test', 'sub', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', 'sub', '-h']));
      expect(argResults.rest, equals(['test', 'sub']));
      expect(argResults.command == null, true);
    });

    test('with subcommand and unsupported flag.', () {
      final ArgResults argResults = runner.parse(['test', 'sub', '-v']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', 'sub', '-v']));
      expect(argResults.rest, equals(['test', 'sub', '-v']));
      expect(argResults.command == null, true);
    });
  }));

  group('WrapperRunner.parse should work when args is supported command', (() {
    final runner = TestRunner()..addCommand(TestCommand('test'));

    test('', () {
      final ArgResults argResults = runner.parse(['test']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
    });

    test('with -h flag.', () {
      final ArgResults argResults = runner.parse(['test', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', '-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
    });

    test('with unsupported flag.', () {
      expect(() => runner.parse(['test', '-v']), throwsException);
    });

    test('with subcommand.', () {
      final ArgResults argResults = runner.parse(['test', 'sub']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', 'sub']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
    });

    test('with subcommand and -h flag.', () {
      final ArgResults argResults = runner.parse(['test', 'sub', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['test', 'sub', '-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
    });

    test('with subcommand and unsupported flag.', () {
      expect(() => runner.parse(['test', 'sub', '-v']), throwsException);
    });
  }));
}
