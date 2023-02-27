import 'dart:async';

import 'package:flutterw/flutterw.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterwRunner.run', (() {
    test('run empty args should only print usage', () async {
      final runner = FlutterwRunner();
      final usage = runner.usage;
      final output = <String>[];

      /// no flag
      await runZoned(() async {
        await runner.run([]);
      }, zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          output.add(line);
        },
      ));
      expect(usage, equals(output.join('\n')));
    });
    test('should trigger matched hooks by default', () async {
      final runner = FlutterwRunner(scripts: {
        'create': ['foo bar']
      });
      await expectLater(runner.run(['create']), throwsException);
    });
    test('should not trigger matched hooks when args containing -h,--help ',
        () async {
      final runner = FlutterwRunner(scripts: {
        'create': ['foo bar'],
      });
      await expectLater(runner.run(['create', '-h']), completes);
    });
  }));
}
