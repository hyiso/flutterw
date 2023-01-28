import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('HookRunner without hooks should run', (() {
    final preFooHook = TestHook('pre:foo');
    final postBarHook = TestHook('post:bar');
    test('for command', () async {
      final runner = TestRunner({});
      runner.addCommand(TestCommand('foo'));
      runner.addCommand(TestCommand('bar'));
      await runner.run(['foo']);
      expect(preFooHook.isTriggered, false);
      expect(postBarHook.isTriggered, false);
      await runner.run(['bar']);
      expect(preFooHook.isTriggered, false);
      expect(postBarHook.isTriggered, false);
    });

    test('for subcommand', () async {
      final runner = TestRunner({});
      runner.addCommand(TestCommand('foo')..addSubcommand(TestCommand('bar')));
      await runner.run(['foo', 'bar']);
      expect(preFooHook.isTriggered, false);
      expect(postBarHook.isTriggered, false);
    });
  }));

  group('HookRunner with pre and post hooks should run', (() {
    test('for command', () async {
      final preFooHook = TestHook('pre:foo');
      final postBarHook = TestHook('post:bar');
      final hooks = {
        preFooHook.name: preFooHook,
        postBarHook.name: postBarHook,
      };
      final runner = TestRunner(hooks);
      runner.addCommand(TestCommand('foo'));
      runner.addCommand(TestCommand('bar'));
      await runner.run(['foo']);
      expect(preFooHook.isTriggered, true);
      expect(postBarHook.isTriggered, false);
      await runner.run(['bar']);
      expect(postBarHook.isTriggered, true);
    });

    test('for subcommand', () async {
      final preFooHook = TestHook('pre:foo');
      final preFooBarHook = TestHook('pre:foo:bar');
      final postFooHook = TestHook('post:foo');
      final hooks = {
        preFooHook.name: preFooHook,
        preFooBarHook.name: preFooBarHook,
        postFooHook.name: postFooHook,
      };
      final runner = TestRunner(hooks);
      runner.addCommand(TestCommand('foo')..addSubcommand(TestCommand('bar')));
      await runner.run(['foo', 'bar']);
      expect(preFooHook.isTriggered, false);
      expect(preFooBarHook.isTriggered, true);
      expect(postFooHook.isTriggered, true);
    });
  }));

  group('HookRunner with command hooks should run', (() {
    test('for command', () async {
      final fooHook = TestHook('foo');
      final hooks = {
        fooHook.name: fooHook,
      };
      final runner = TestRunner(hooks);
      runner.addCommand(TestCommand('foo'));
      await runner.run(['foo']);
      expect(fooHook.isTriggered, true);
    });

    test('for subcommand', () async {
      final fooHook = TestHook('foo');
      final fooBarHook = TestHook('foo:bar');
      final hooks = {
        fooHook.name: fooHook,
        fooBarHook.name: fooBarHook,
      };
      final runner = TestRunner(hooks);
      await runner.run(['foo', 'bar']);
      expect(fooHook.isTriggered, false);
      expect(fooBarHook.isTriggered, true);
    });

    test('for colon-joined command', () async {
      final fooHook = TestHook('foo');
      final fooBarHook = TestHook('foo:bar');
      final hooks = {
        fooHook.name: fooHook,
        fooBarHook.name: fooBarHook,
      };
      await TestRunner(hooks).run(['foo:bar']);
      expect(fooHook.isTriggered, false);
      expect(fooBarHook.isTriggered, true);
    });
  }));
}
