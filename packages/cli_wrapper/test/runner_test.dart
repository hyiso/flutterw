import 'package:args/args.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('WrapperRunner.parse should work when', (() {
    test('args is empty.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse([]);
      expect(argResults.arguments.isEmpty, true);
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, true);
    });
    test('args is supported flag.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse(['-h']);
      expect(argResults.arguments, equals(['-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, true);
    });
    test('args is unsupported flag.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse(['--version']);
      expect(argResults.arguments, equals(['--version']));
      expect(argResults.rest, equals(['--version']));
      expect(argResults.command == null, true);
    });

    test('args is single command.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse(['test']);
      expect(argResults.arguments, equals(['test']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
      expect(argResults.command!.name, equals('test'));
      expect(argResults.command!.arguments.isEmpty, true);
      expect(argResults.command!.rest.isEmpty, true);
      expect(argResults.command!.command == null, true);
    });

    test('args is single command with arguments.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse(['test', '-h']);
      expect(argResults.arguments, equals(['test', '-h']));
      expect(argResults.rest, equals(['-h']));
      expect(argResults.command == null, false);
      expect(argResults.command!.name, equals('test'));
      expect(argResults.command!.arguments, equals(['-h']));
      expect(argResults.command!.rest, equals(['-h']));
      expect(argResults.command!.command == null, true);
    });

    test('args is multi commands.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse(['test', 'sub']);
      expect(argResults.arguments, equals(['test', 'sub']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
      expect(argResults.command!.name, equals('test'));
      expect(argResults.command!.arguments, equals(['sub']));
      expect(argResults.command!.rest.isEmpty, true);
      expect(argResults.command!.command == null, false);
      expect(argResults.command!.command!.name, equals('sub'));
      expect(argResults.command!.command!.arguments.isEmpty, true);
      expect(argResults.command!.command!.rest.isEmpty, true);
      expect(argResults.command!.command!.command == null, true);
    });

    test('args is multi command with arguments.', () {
      final runner = TestRunner();
      final ArgResults argResults = runner.parse(['test', 'sub', '-h']);
      expect(argResults.arguments, equals(['test', 'sub', '-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);
      expect(argResults.command!.name, equals('test'));
      expect(argResults.command!.arguments, equals(['sub', '-h']));
      expect(argResults.command!.rest, equals(['-h']));
      expect(argResults.command!.command == null, false);
      expect(argResults.command!.command!.name, equals('sub'));
      expect(argResults.command!.command!.arguments, equals(['-h']));
      expect(argResults.command!.command!.rest, equals(['-h']));
      expect(argResults.command!.command!.command == null, true);
    });
  }));
}
