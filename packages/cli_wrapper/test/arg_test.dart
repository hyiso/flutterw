import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:test/test.dart';

void main() {
  group('WrapperArgParser', (() {
    final wParser = WrapperArgParser();

    test('.parse() should work.', () {
      var wResults = wParser.parse(['clean', '-v']);

      expect(wResults.commands, equals(['clean']));
      expect(wResults.underlineCommand, equals('clean'));
      expect(wResults.arguments, equals(['-v']));
      expect(wResults.rest, equals([]));

      wResults = wParser.parse(['create', '-t', 'app', 'my_app']);
      expect(wResults.commands, equals(['create']));
      expect(wResults.underlineCommand, equals('create'));
      expect(wResults.arguments, equals(['-t', 'app', 'my_app']));
      expect(wResults.rest, equals(['my_app']));

      wResults = wParser
          .parse(['build', 'ios-framework', '--no-profile', '--no-debug']);
      expect(wResults.commands, equals(['build', 'ios-framework']));
      expect(wResults.underlineCommand, equals('build_ios_framework'));
      expect(wResults.arguments, equals(['--no-profile', '--no-debug']));
      expect(wResults.rest, equals([]));

      wResults = wParser.parse(['build', 'aar', '--no-profile', '--no-debug']);
      expect(wResults.commands, equals(['build', 'aar']));
      expect(wResults.underlineCommand, equals('build_aar'));
      expect(wResults.arguments, equals(['--no-profile', '--no-debug']));
      expect(wResults.rest, equals([]));
    });
  }));
}
