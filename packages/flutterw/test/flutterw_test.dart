import 'dart:io';

import 'package:flutterw/flutterw.dart';
import 'package:path/path.dart' show join;
import 'package:test/test.dart';

void main() {
  group('flutterw should work', (() {
    final outputFile = File(join('lib', 'src', 'version.g.dart'));
    final outputContent = outputFile.readAsStringSync();
    tearDownAll(() => outputFile.writeAsStringSync(outputContent));
    test('with hooks.', () async {
      final runner = FlutterwRunner(
          config: FlutterwConfig.fromFile(File('flutterw.yaml')));
      outputFile.writeAsStringSync('');
      expect(outputFile.readAsStringSync(), equals(''));

      await runner.run(['pub', 'publish', '--dry-run']);
      expect(outputFile.readAsStringSync(), outputContent);
    });
  }));
}
