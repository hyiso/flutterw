import 'package:cli_hook/cli_hook.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('Hook.lookup should work', (() {
    test('without hooks', () {
      final commandHooks = Hook.lookup(
        commands: ['foo', 'bar'],
        hooks: {},
      );
      expect(commandHooks.item1, equals(null));
      expect(commandHooks.item2, equals(null));
      expect(commandHooks.item3, equals(null));
    });
    test('with hooks', () {
      final preFooHook = TestHook('pre:foo');
      final preFooBarHook = TestHook('pre:foo:bar');
      final postFooHook = TestHook('post:foo');
      final commandHooks = Hook.lookup(
        commands: ['foo', 'bar'],
        hooks: {
          preFooHook.name: preFooHook,
          preFooBarHook.name: preFooBarHook,
          postFooHook.name: postFooHook,
        },
      );
      expect(commandHooks.item1 != null, true);
      expect(commandHooks.item1!.item1, equals(preFooBarHook));
      expect(commandHooks.item1!.item2.isEmpty, true);
      expect(commandHooks.item2, equals(null));
      expect(commandHooks.item3 != null, true);
      expect(commandHooks.item3!.item1, equals(postFooHook));
      expect(commandHooks.item3!.item2.isEmpty, false);
      expect(commandHooks.item3!.item2, equals(['bar']));
    });
  }));
}
