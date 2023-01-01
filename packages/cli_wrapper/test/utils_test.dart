import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:test/test.dart';

void main() {
  group('lookupPluginCommand should work', (() {
    final prefix = 'foo_';
    final commands = ['bar', 'baz'];
    final hittedRootPlugin = ['foo_bar', 'baz'];
    final hittedLeafPlugin = ['foo_bar_baz'];
    final onlyRootPluginExists = {'foo_bar': 1};
    final onlyLeafPluginExists = {'foo_bar_baz': 1};
    final bothPluginExist = {'foo_bar': 1, 'foo_bar_baz': 1};

    test('without plugins', () {
      var result = lookupPluginCommand({}, commands, prefix);
      expect(result, equals(null));
    });

    test('when only root plugin exists', () {
      var result = lookupPluginCommand(onlyRootPluginExists, commands, prefix);
      expect(result, equals(hittedRootPlugin));
    });

    test('when only leaf plugin exists', () {
      var result = lookupPluginCommand(onlyLeafPluginExists, commands, prefix);
      expect(result, equals(hittedLeafPlugin));
    });

    test('when both leaf and root plugin exist', () {
      var result = lookupPluginCommand(bothPluginExist, commands, prefix);
      expect(result, equals(hittedLeafPlugin));
    });
  }));
}
