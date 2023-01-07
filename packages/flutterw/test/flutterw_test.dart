import 'dart:io';

import 'package:flutterw/flutterw.dart';
import 'package:test/test.dart';

void main() {
  group('flutterw', (() {
    test('should work without config.', () async {
      final runner = FlutterwRunner();

      final dartTool = '.dart_tool';
      final dartToolDir = Directory(dartTool);

      expect(dartToolDir.existsSync(), true);

      await runner.run(['clean']);
      expect(dartToolDir.existsSync(), false);

      await runner.run(['pub', 'get']);
      expect(dartToolDir.existsSync(), true);
    });
  }));
}
