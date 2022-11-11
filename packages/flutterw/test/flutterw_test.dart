import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:test/test.dart';

void main() {
  group('flutterw', (() {
    final rootDir = Directory.current.parent.parent;

    final examplesDir = Directory(join(rootDir.path, 'examples'));

    setUp(() {
      Process.runSync(
          'dart', ['pub', 'global', 'activate', '--source', 'path', '.']);
    });

    tearDown(() {
      Process.runSync('dart', ['pub', 'global', 'deactivate', 'flutterw']);
    });

    test('origin comamnds should work.', () {
      final testExample = 'test_example';
      final testExampleDir = Directory(join(examplesDir.path, testExample));
      if (testExampleDir.existsSync()) {
        testExampleDir.deleteSync(recursive: true);
      }

      Process.runSync(
          'flutterw', ['create', '-t', 'package', testExample, '--no-pub'],
          workingDirectory: examplesDir.path);
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

      Process.runSync('flutterw', ['clean'],
          workingDirectory: testExampleDir.path);
      expect(dartToolDir.existsSync(), false);

      if (testExampleDir.existsSync()) {
        testExampleDir.deleteSync(recursive: true);
      }
    });

    test('hooks should work.', () {
      final hooksExample = 'hooks_example';
      final hooksExampleDir = Directory(join(examplesDir.path, hooksExample));

      String stderrMessage = Process.runSync('flutterw', ['clean'],
              workingDirectory: hooksExampleDir.path)
          .stderr;
      expect(stderrMessage.contains('pre_clean'), true);

      stderrMessage = Process.runSync('flutterw', ['pub', 'get'],
              workingDirectory: hooksExampleDir.path)
          .stderr;
      expect(stderrMessage.contains('post_pub_get'), true);
    });

    test('plugins should work.', () {
      final pluginsExample = 'plugins_example';
      final pluginsExampleDir =
          Directory(join(examplesDir.path, pluginsExample));

      Process.runSync('flutterw', ['pub', 'get'],
              workingDirectory: pluginsExampleDir.path)
          .stderr;

      String stderrMessage = Process.runSync('flutterw', ['clean'],
              workingDirectory: pluginsExampleDir.path)
          .stderr;
      expect(stderrMessage.contains('clean:flutterw_clean'), true);
    });
  }));
}
