import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_hook/cli_hook.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:cli_wrapper/cli_wrapper.dart';

import 'commands/help.dart';
import 'config.dart';
import 'version.g.dart';

/// A class that can run Flutterw with hooks system support.
///
/// To run a command, do:
///
/// ```dart main
/// final flutterw = FlutterwRunner();
///
/// await flutterw.run(['pub', 'get']);
/// ```
class FlutterwRunner extends CommandRunner with WrapperRunner, HookRunner {
  FlutterwRunner({
    this.config,
    Logger? logger,
  })  : logger = logger ?? Logger.standard(),
        super('flutterw', 'flutterw wraps flutter with command hooks system');

  final Logger logger;

  final FlutterwConfig? config;

  @override
  String get originExecutableName => 'flutter';

  @override
  Map<String, Hook> get hooks => config?.hooks ?? {};

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

  @override
  Future runCommand(ArgResults topLevelResults) {
    if (topLevelResults.command == null) {
      if (topLevelResults.rest.isNotEmpty &&
          topLevelResults.rest.contains('--version')) {
        logger.stderr('Flutterw $kFlutterwVersion');
      }
    }
    return super.runCommand(topLevelResults);
  }
}
