import 'package:args/args.dart';
import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:test/test.dart';

void main() {
  group('WrapperRunner', (() {
    final runner = WrapperRunner('cliw', 'cli');
    late ArgResults argResults;

    test('.parse() should work.', () {
      argResults = runner.parse(['-h']);
      expect(argResults.command?.name, equals(null));
      expect(argResults.rest.isEmpty, true);

      argResults = runner.parse(['--version']);
      expect(argResults.command?.name, equals(null));
      expect(argResults.rest.isEmpty, false);

      argResults = runner.parse(['leaf']);
      expect(argResults.command?.name, equals('leaf'));

      argResults = runner.parse(['parent', 'command']);
      expect(argResults.command?.name, equals('parent'));
    });
  }));
}
