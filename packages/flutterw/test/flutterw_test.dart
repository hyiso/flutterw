import 'package:flutterw/runner.dart';
import 'package:test/test.dart';

void main() {
  group('WrapperRunner', (() {
    final runner = WrapperRunner('flutter');

    test('.parse() should work.', () {
      var argResults = runner.parse(['init']);

      expect(argResults.command?.name == 'init', true);

      argResults = runner.parse(['clean']);
      expect(argResults.name == null, true);
      expect(argResults.command?.name == 'flutter', true);

      argResults = runner.parse(['--version']);
      expect(argResults.command?.name == 'flutter', true);
    });
  }));
}
