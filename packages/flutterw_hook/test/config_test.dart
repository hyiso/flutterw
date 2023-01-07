import 'dart:io';

import 'package:flutterw_hook/flutterw_hook.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterwHookConfig', () {
    final configFile = File('flutterw.yaml');

    setUpAll(() => configFile.createSync());

    tearDownAll(() => configFile.deleteSync());

    test('addHook should work', () async {
      expect(config.hooks.isEmpty, true);
      await config.addHook(name: 'hook', package: 'flutterw_hook');
      expect(config.hooks.isNotEmpty, true);
      expect(config.hooks['hook'] != null, true);
      expect(config.hooks['hook']!.package, equals('flutterw_hook'));
    });

    test('removeHook should work', () async {
      expect(config.hooks.isNotEmpty, true);
      expect(config.hooks['hook'] != null, true);
      expect(config.hooks['hook']!.package, equals('flutterw_hook'));
      await config.removeHook(name: 'hook');
      expect(config.hooks.isEmpty, true);
    });
  });
}
