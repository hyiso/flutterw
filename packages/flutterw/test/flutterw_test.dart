import 'dart:io';

import 'package:flutterw/flutterw.dart';
import 'package:test/test.dart';

void main() {
  test('flutterw should work.', () async {
    final runner = FlutterwRunner(
        config: FlutterwConfig.empty());
    final dartToolDir = Directory('.dart_tool');
    expect(dartToolDir.existsSync(), true);

    await runner.run(['clean']);
    expect(dartToolDir.existsSync(), false);

    await runner.run(['pub', 'get']);
    expect(dartToolDir.existsSync(), true);
  });
}
