import 'package:args/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('WrapperRunner.run should work when', (() {
    test('args is empty.', () async {
      final runner = TestRunner();
      await runner.run([]);
      expect(runner.isPrintUsageCalled, true);
      expect(runner.isOriginTriggered, false);
    });
    test('args is -h flag.', () async {
      final runner = TestRunner();
      await runner.run(['-h']);
      expect(runner.isPrintUsageCalled, true);
      expect(runner.isOriginTriggered, false);
    });
    test('args is unsupported flag.', () async {
      final runner = TestRunner();
      try {
        await runner.run(['-v']);
      } catch (e) {
        expect(e, isA<UsageException>());
      }
    });
  }));

  group('WrapperRunner.run should work when args is unsupported command', (() {
    test('', () async {
      final runner = TestRunner();
      await runner.run(['test']);
      expect(runner.isOriginTriggered, true);
      expect(runner.runOriginArguments, equals(['test']));
    });

    test('with -h flag.', () async {
      final runner = TestRunner();
      await runner.run(['test', '-h']);
      expect(runner.isOriginTriggered, true);
      expect(runner.runOriginArguments, equals(['test', '-h']));
    });

    test('with unsupported flag.', () async {
      final runner = TestRunner();
      await runner.run(['test', '-v']);
      expect(runner.isOriginTriggered, true);
      expect(runner.runOriginArguments, equals(['test', '-v']));
    });

    test('with subcommand.', () async {
      final runner = TestRunner();
      await runner.run(['test', 'sub']);
      expect(runner.isOriginTriggered, true);
      expect(runner.runOriginArguments, equals(['test', 'sub']));
    });

    test('with subcommand and -h flag.', () async {
      final runner = TestRunner();
      await runner.run(['test', 'sub', '-h']);
      expect(runner.isOriginTriggered, true);
      expect(runner.runOriginArguments, equals(['test', 'sub', '-h']));
    });

    test('with subcommand and unsupported flag.', () async {
      final runner = TestRunner();
      await runner.run(['test', 'sub', '-v']);
      expect(runner.isOriginTriggered, true);
      expect(runner.runOriginArguments, equals(['test', 'sub', '-v']));
    });
  }));

  group('WrapperRunner.parse should work when args is supported command', (() {
    test('', () async {
      final testCommand = TestCommand('test');
      final runner = TestRunner()..addCommand(testCommand);
      await runner.run(['test']);
      expect(runner.isPrintUsageCalled, false);
      expect(runner.isOriginTriggered, false);
      expect(testCommand.isTriggered, true);
      expect(testCommand.isPrintUsageCalled, false);
    });

    test('with -h flag.', () async {
      final testCommand = TestCommand('test');
      final runner = TestRunner()..addCommand(testCommand);
      await runner.run(['test', '-h']);
      expect(runner.isPrintUsageCalled, false);
      expect(runner.isOriginTriggered, false);
      expect(testCommand.isTriggered, false);
      expect(testCommand.isPrintUsageCalled, true);
    });

    test('with unsupported flag.', () async {
      final testCommand = TestCommand('test');
      final runner = TestRunner()..addCommand(testCommand);
      try {
        await runner.run(['test', '-v']);
      } catch (e) {
        expect(e, isA<UsageException>());
      }
    });

    test('with subcommand.', () async {
      final testCommand = TestCommand('test');
      final runner = TestRunner()..addCommand(testCommand);
      await runner.run(['test', 'sub']);
      expect(runner.isPrintUsageCalled, false);
      expect(runner.isOriginTriggered, false);
      expect(testCommand.isTriggered, true);
      expect(testCommand.isPrintUsageCalled, false);
    });

    test('with subcommand and -h flag.', () async {
      final testCommand = TestCommand('test');
      final runner = TestRunner()..addCommand(testCommand);
      await runner.run(['test', 'sub', '-h']);
      expect(runner.isPrintUsageCalled, false);
      expect(runner.isOriginTriggered, false);
      expect(testCommand.isTriggered, false);
      expect(testCommand.isPrintUsageCalled, true);
    });

    test('with subcommand and unsupported flag.', () async {
      final testCommand = TestCommand('test');
      final runner = TestRunner()..addCommand(testCommand);
      try {
        await runner.run(['test', 'sub', '-v']);
      } catch (e) {
        expect(e, isA<UsageException>());
      }
    });
  }));
}
