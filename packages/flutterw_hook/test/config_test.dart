import 'package:flutterw_hook/flutterw_hook.dart';
import 'package:test/test.dart';

void main() {
  group('WrittableFlutterwConfig', () {
    test('addHook should work', () async {
      expect(config.scripts.isEmpty, true);
      await config.addHook(name: 'hook', package: 'flutterw_hook');
      expect(config.scripts.isNotEmpty, true);
      expect(config.scripts['hook'] != null, true);
      expect(config.scripts['hook'], equals('flutterw_hook'));
    });

    test('removeHook should work', () async {
      expect(config.scripts.isNotEmpty, true);
      expect(config.scripts['hook'] != null, true);
      expect(config.scripts['hook'], equals('flutterw_hook'));
      await config.removeHook(name: 'hook');
      expect(config.scripts.isEmpty, true);
    });
  });
}
