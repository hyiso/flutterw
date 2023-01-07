import 'package:args/command_runner.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {

  // group('HookCommand.stacks should work', (() {
  //   test('for command', () {
  //     final fooCommand = TestCommand('foo');
  //     final barCommand = TestCommand('bar');
  //     expect(fooCommand.stacks, equals(['foo']));
  //     expect(barCommand.stacks, equals(['bar']));
  //   });

  //   test('for command subcommand', () {
  //     final fooCommand = TestCommand('foo');
  //     final barCommand = TestCommand('bar');
  //     fooCommand.addSubcommand(barCommand);
  //     expect(fooCommand.stacks, equals(['foo']));
  //     expect(barCommand.stacks, equals(['foo', 'bar']));
  //   });
  // }));

  group('HookRunner without hooks should run', (() {

    final preFooHook = TestHook('pre:foo');
    final postBarHook = TestHook('post:bar');
    test('for command', () async {
      final runner = CommandRunner('test', 'test');
      runner.addCommand(TestCommand('foo'));
      runner.addCommand(TestCommand('bar'));
      await runner.run(['foo']);
      expect(preFooHook.isTriggered, false);
      expect(postBarHook.isTriggered, false);
      await runner.run(['bar']);
      expect(preFooHook.isTriggered, false);
      expect(postBarHook.isTriggered, false);
    });

    test('for command subcommand', () async {
      final runner = CommandRunner('test', 'test');
      runner.addCommand(TestCommand('foo')..addSubcommand(TestCommand('bar')));
      await runner.run(['foo', 'bar']);
      expect(preFooHook.isTriggered, false);
      expect(postBarHook.isTriggered, false);
    });
  }));

  group('HookRunner with hooks should run', (() {
    test('for command', () async {
      final preFooHook = TestHook('pre:foo');
      final postBarHook = TestHook('post:bar');
      final hooks = {
        preFooHook.name: preFooHook,
        postBarHook.name: postBarHook,
      };
      final runner = TestRunner(hooks);
      final fooCommand = TestCommand('foo');
      final barCommand = TestCommand('bar');
      runner.addCommand(fooCommand);
      runner.addCommand(barCommand);
      await runner.run(['foo']);
      expect(preFooHook.isTriggered, true);
      expect(postBarHook.isTriggered, false);
      await runner.run(['bar']);
      expect(postBarHook.isTriggered, true);
    });

    test('for command subcommand', () async {
      final preFooHook = TestHook('pre:foo');
      final preFooBarHook = TestHook('pre:foo:bar');
      final postFooHook = TestHook('post:foo');
      final hooks = {
        preFooHook.name: preFooHook,
        preFooBarHook.name: preFooBarHook,
        postFooHook.name: postFooHook,
      };
      final runner = TestRunner(hooks);
      final fooCommand = TestCommand('foo');
      final barCommand = TestCommand('bar');
      runner.addCommand(fooCommand);
      fooCommand.addSubcommand(barCommand);
      await runner.run(['foo', 'bar']);
      expect(preFooHook.isTriggered, false);
      expect(preFooBarHook.isTriggered, true);
      expect(postFooHook.isTriggered, true);
    });
  }));
}
