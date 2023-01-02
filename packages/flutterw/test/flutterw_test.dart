import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:test/test.dart';

void main() {
  group('flutterw', (() {

    setUp(() {
      Process.runSync(
          'dart', ['pub', 'global', 'activate', '--source', 'path', '.']);
    });

    tearDown(() {
      Process.runSync('dart', ['pub', 'global', 'deactivate', 'flutterw']);
    });

    test('origin comamnds should work.', () {
      final testExample = 'test_example';
      final testExampleDir = Directory(join(Directory.current.path, testExample));
      if (testExampleDir.existsSync()) {
        testExampleDir.deleteSync(recursive: true);
      }

      Process.runSync(
          'flutterw', ['create', '-t', 'package', testExample, '--no-pub']);
      expect(testExampleDir.existsSync(), true);

      final testExamplePubspec =
          File(join(testExampleDir.path, 'pubspec.yaml'));
      expect(testExamplePubspec.existsSync(), true);

      final dartTool = '.dart_tool';
      final dartToolDir = Directory(join(testExampleDir.path, dartTool));

      expect(dartToolDir.existsSync(), false);

      Process.runSync('flutterw', ['pub', 'get'],
          workingDirectory: testExampleDir.path);
      expect(dartToolDir.existsSync(), true);

      if (testExampleDir.existsSync()) {
        testExampleDir.deleteSync(recursive: true);
      }
    });

    test('hooks should work.', () {
      final exampleDir = Directory(join(Directory.current.path, 'example'));

      Process.runSync('flutterw', ['pub', 'get'],
          workingDirectory: exampleDir.path);

      String stderrMessage = Process.runSync('flutterw', ['clean'],
              workingDirectory: exampleDir.path)
          .stderr;
      expect(stderrMessage.contains('pre_clean'), true);
      expect(stderrMessage.contains('flutter pub run flutterw_clean'), true);
      expect(stderrMessage.contains('post_clean'), true);
    });
  }));
}
