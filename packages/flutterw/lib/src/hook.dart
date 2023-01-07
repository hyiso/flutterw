import 'dart:io';

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
  final String name;

  @override
  final List<String> scripts;

  final String package;

  FlutterwHook.fromScripts({
    required this.name,
    required this.scripts,
    Logger? logger,
  }) : package = '';

  @override
  bool get isVerbose => package.isNotEmpty;

  FlutterwHook.fromPackage({
    required this.name,
    required this.package,
    bool global = false,
  }) : scripts = [package.toCmd(global)];

  @override
  Future<void> run(Iterable<String> args) async {
    stderr.writeln('Run hook $name');
    return await super.run(args);
  }

  @override
  Future<void> execScript(String script, Iterable<String> args) async {
    stderr.writeln('  └> $script');
    if (package.isNotEmpty) {
      return await super.execScript(script, args);
    } else {
      return await super.execScript(script, []);
    }
  }
}
