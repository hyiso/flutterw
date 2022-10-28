import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'src/commands/wrapper.dart';

import 'version.g.dart';

class FlutterwRunner extends CommandRunner<dynamic> {
  FlutterwRunner(): super(
    'flutterw',
    'flutterw wraps flutter tool with more advanced usage.',
  ) {
    addCommand(WrapperCommand('flutter', ''));
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
        results = super.parse(['flutter', ...args]);
      }
    } on ArgParserException catch (e) {
      if (e.commands.isEmpty && args.contains('--version')) {
        stderr.writeln('flutterw • $kPackageVersion');
      }
      results = super.parse(['flutter', ...args]);
    }
    return results;
  }

  @override
  String get invocation => '${super.invocation}'
''' as flutter <command> [arguments]
i.e.:
       flutterw clean
       flutterw pub get
       ...''';
}
