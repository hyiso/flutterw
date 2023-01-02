import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';

import 'commands/help.dart';
import 'commands/hook.dart';

class FlutterWrapperRunner extends WrapperRunner {
  FlutterWrapperRunner(Map<String, Hook> hooks)
      : super('flutterw', 'flutter', hooks: hooks) {
    addCommand(HookCommand());
  }

  @override
  String get description => 'flutterw wraps flutter tool with advanced usage.';

  @override
  String get originExecutableName => 'flutter';

  @override
  String? get usageFooter =>
      '\nAnd use flutterw as flutter to enable hooks and plugins:\n'
      '  flutterw doctor\n'
      '  flutterw clean\n'
      '  flutterw pub get\n'
      '  ...';

  @override
  void addCommand(Command command) {
    if (command.name == 'help') {
      super.addCommand(HelpCommand());
    } else {
      super.addCommand(command);
    }
  }
}
