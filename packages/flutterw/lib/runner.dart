import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'src/commands/init.dart';
import 'src/commands/wrapper.dart';

class WrapperRunner extends CommandRunner {

  final String origin;

  WrapperRunner(this.origin): super(
    '${origin}w',
    '${origin}w wraps $origin cli tool with more advanced usage.',
  ) {
    addCommand(InitCommand());
    addCommand(WrapperCommand(origin));
  }

  @override
  ArgResults parse(Iterable<String> args) {
    ArgResults results;
    try {
      results = argParser.parse(args);
      if (
        results.command == null &&
        results.arguments.isNotEmpty &&
        results.rest.isNotEmpty
      ) {
        results = super.parse([origin, ...args]);
      }
    // ignore: unused_catch_clause
    } on ArgParserException catch (e) {
      results = super.parse([origin, ...args]);
    }
    return results;
  }

  @override
  String get invocation => '${super.invocation}'
''' as $origin <command> [arguments]
i.e.:
       $executableName pub get
       $executableName run
       ...''';

}