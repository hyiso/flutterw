import 'package:args/args.dart';
import 'package:flutterw/flutterw.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterwRunner.parse', (() {
    test('can parse args without command', () {
      final runner = FlutterwRunner();

      /// no flag
      ArgResults argResults = runner.parse([]);
      expect(argResults.name == null, true);
      expect(argResults.arguments.isEmpty, true);
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, true);

      /// -h flag
      argResults = runner.parse(['-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, true);

      /// original supported falg only
      argResults = runner.parse(['--version']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['--version']));
      expect(argResults.rest, equals(['--version']));
      expect(argResults.command == null, true);
    });
    test('can parse args for self command', () {
      final runner = FlutterwRunner();

      /// self command
      ArgResults argResults = runner.parse(['help']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['help']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);

      /// self command with supported flag
      argResults = runner.parse(['help', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['help', '-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);

      /// self command with unsupported flag
      expect(() => runner.parse(['help', '-v']), throwsException);

      /// self command with positioned argument
      argResults = runner.parse(['help', 'sub']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['help', 'sub']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);

      /// self command with orpositioned argument and supported flag
      argResults = runner.parse(['help', 'sub', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['help', 'sub', '-h']));
      expect(argResults.rest.isEmpty, true);
      expect(argResults.command == null, false);

      /// self command with positioned argument and unsupported flag
      expect(() => runner.parse(['help', 'sub', '-v']), throwsException);
    });
    test('can parse args for original command', () {
      final runner = FlutterwRunner();

      /// no flag
      ArgResults argResults = runner.parse(['attach']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['attach']));
      expect(argResults.rest.isEmpty, false);
      expect(argResults.command == null, true);

      /// -h flag
      argResults = runner.parse(['attach', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['attach', '-h']));
      expect(argResults.rest, equals(['attach']));
      expect(argResults.command == null, true);

      /// original supported flag only
      argResults = runner.parse(['attach', '-d', 'xx']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['attach', '-d', 'xx']));
      expect(argResults.rest, equals(['attach', '-d', 'xx']));
      expect(argResults.command == null, true);

      /// subcommand only
      argResults = runner.parse(['build', 'aar']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['build', 'aar']));
      expect(argResults.rest, equals(['build', 'aar']));
      expect(argResults.command == null, true);

      /// subcommand and -h flag
      argResults = runner.parse(['build', 'aar', '-h']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['build', 'aar', '-h']));
      expect(argResults.rest, equals(['build', 'aar']));
      expect(argResults.command == null, true);

      /// subcommand and original flag
      argResults = runner.parse(['build', 'aar', '--no-debug']);
      expect(argResults.name == null, true);
      expect(argResults.arguments, equals(['build', 'aar', '--no-debug']));
      expect(argResults.rest, equals(['build', 'aar', '--no-debug']));
      expect(argResults.command == null, true);
    });
  }));
}
