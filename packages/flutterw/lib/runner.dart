import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';

import 'src/commands/help.dart';
import 'src/commands/plugin.dart';
import 'src/commands/wrapper.dart';

class FlutterWrapperRunner extends WrapperRunner {
  FlutterWrapperRunner() : super('flutterw', 'flutter') {
    addCommand(PluginCommand());
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
  void addWrapperCommand([String name = '']) {
    if (name == 'help') {
      addCommand(HelpCommand());
    } else {
      addCommand(FlutterWrapperCommand(name: name));
    }
  }
}
