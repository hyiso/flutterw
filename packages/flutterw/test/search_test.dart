import 'package:flutterw/src/search.dart';
import 'package:test/test.dart';

void main() {
  group('searchCommandHooks', (() {
    test('find no hook when hooks is empty', () {
      final commandHooks = searchCommandHooks(
        args: ['foo', 'bar'],
        scripts: {},
      );
      expect(commandHooks.item1, equals(null));
      expect(commandHooks.item2, equals(null));
      expect(commandHooks.item3, equals(null));
    });
    test('find commands hooks when hooks match running args', () {
      final preFoo = 'pre:foo';
      final preFooBar = 'pre:foo:bar';
      final postFoo = 'post:foo';
      final commandHooks = searchCommandHooks(
        args: ['foo', 'bar'],
        scripts: {
          preFoo: preFoo,
          preFooBar: preFooBar,
          postFoo: postFoo,
        },
      );
      expect(commandHooks.item1 != null, true);
      expect(commandHooks.item1!.item1, equals(preFooBar));
      expect(commandHooks.item1!.item2.isEmpty, true);

      expect(commandHooks.item2, equals(null));

      expect(commandHooks.item3 != null, true);
      expect(commandHooks.item3!.item1, equals(postFoo));
      expect(commandHooks.item3!.item2.isEmpty, false);
      expect(commandHooks.item3!.item2, equals(['bar']));
    });
  }));
}
