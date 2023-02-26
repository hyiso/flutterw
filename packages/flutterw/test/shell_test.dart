import 'package:flutterw/src/shell.dart';
import 'package:test/test.dart';

void main() {
  group('buildExecutableArgs', (() {
    test('replace <args> with runtime args if <args> exists.', () async {
      final result = buildExecutableArgs(
          'build aar <args>', ['--no-debug', '--no-profile']);
      expect(result, equals(['build', 'aar', '--no-debug', '--no-profile']));
    });
    test('return original shell cmds', () async {
      final result =
          buildExecutableArgs('build aar', ['--no-debug', '--no-profile']);
      expect(result, equals(['build', 'aar']));
    });
  }));
  group('runShells', (() {
    test('return 0 code when shell success', () async {
      expect(await runShells(['echo "test"'], []), equals(0));
    });
    test('exit when shell failed', () async {
      await expectLater(runShells(['foo bar'], []), throwsException);
    });
  }));
}
