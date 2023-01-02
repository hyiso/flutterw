import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:test/test.dart';

void main() {
  group('flutterw', (() {
    final example = 'example';
    final exampleDir = Directory(example);

    setUp(() {
      Process.runSync(
          'dart', ['pub', 'global', 'activate', '--source', 'path', '.']);
    });

    tearDown(() {
      Process.runSync('dart', ['pub', 'global', 'deactivate', 'flutterw']);
    });

    test('origin comamnds should work.', () {
      final exampleFlutterw = File(join(example, 'flutterw.yaml'));
      final exampleReadme = File(join(example, 'README.md'));
      final exampleFlutterwContent = exampleFlutterw.readAsStringSync();
      final exampleReadmeContent = exampleReadme.readAsStringSync();

      if (exampleDir.existsSync()) {
        exampleDir.deleteSync(recursive: true);
      }

      Process.runSync('flutterw', [
        'create',
        '-t',
        'package',
        example,
        '--no-pub',
        '--project-name',
        'flutterw_example'
      ]);
      expect(exampleDir.existsSync(), true);
      Process.runSync(
          'rm', ['-fr', join(example, 'lib'), join(example, 'test')]);

      final examplePubspec = File(join(exampleDir.path, 'pubspec.yaml'));
      expect(examplePubspec.existsSync(), true);

      final dartTool = '.dart_tool';
      final dartToolDir = Directory(join(exampleDir.path, dartTool));

      expect(dartToolDir.existsSync(), false);

      Process.runSync('flutterw', ['pub', 'get'],
          workingDirectory: exampleDir.path);
      expect(dartToolDir.existsSync(), true);

      exampleFlutterw.writeAsStringSync(exampleFlutterwContent);
      exampleReadme.writeAsStringSync(exampleReadmeContent);
    });

    test('hooks should work.', () {
      Process.runSync('dart', ['pub', 'global', 'activate', 'flutterw_clean']);

      Process.runSync(
          'flutterw', ['hook', 'add', 'clean', 'flutterw_clean', '-g']);

      String stderrMessage = Process.runSync('flutterw', ['clean'],
              workingDirectory: exampleDir.path)
          .stderr;
      expect(stderrMessage.contains('pre_clean'), true);
      expect(stderrMessage.contains('flutter pub global run flutterw_clean'),
          true);
      expect(stderrMessage.contains('post_clean'), true);

      Process.runSync('flutterw', ['pub', 'get'],
          workingDirectory: exampleDir.path);
    });
  }));
}
