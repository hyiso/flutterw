import 'package:cli_hook/cli_hook.dart';
import 'package:cli_util/cli_logging.dart';

extension _PackageName on String {
  String toCmd(bool global) => [
        'flutter',
        'pub',
        if (global) 'global',
        'run',
        this,
      ].join(' ');
}

class FlutterwHook extends Hook {
  @override
  final String name;

  @override
  final List<String> scripts;

  final String package;

  final Logger logger;

  FlutterwHook.fromScripts({
    required this.name,
    required this.scripts,
    Logger? logger,
  }) : package = ''
     , logger = logger ?? Logger.standard();

  @override
  bool get isVerbose => package.isNotEmpty;

  FlutterwHook.fromPackage({
    required this.name,
    required this.package,
    Logger? logger,
    bool global = false,
  }) : scripts = [package.toCmd(global)]
     , logger = logger ?? Logger.standard();

  @override
  Future<void> run(Iterable<String> args) {
    logger.stderr('Run hook $name');
    return super.run(args);
  }

  @override
  Future<void> execScript(String script, Iterable<String> args) {
    logger.stderr('  └> $script');
    if (package.isNotEmpty) {
      return super.execScript(script, args);
    } else {
      return super.execScript(script, []);
    }
  }
}
