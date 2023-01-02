import 'dart:io';

import 'package:cli_wrapper/cli_wrapper.dart';

extension _PackageName on String {
  String toCmd(bool global) => [
        'flutter',
        'pub',
        if (global) 'global',
        'run',
        this,
      ].join(' ');
}

class FlutterWrapperHook extends Hook {
  @override
  final String name;

  @override
  final List<String> scripts;

  final String package;

  FlutterWrapperHook.fromScripts({
    required this.name,
    required this.scripts,
  }) : package = '';

  @override
  bool get isVerbose => package.isNotEmpty;

  FlutterWrapperHook.fromPackage({
    required this.name,
    required this.package,
    bool global = false,
  }) : scripts = [package.toCmd(global)];

  @override
  Future<void> run(Iterable<String> args) {
    stderr.writeln('Run hook $name');
    return super.run(args);
  }

  @override
  Future<void> execScript(String script, Iterable<String> args) {
    stderr.writeln('  └> $script');
    if (package.isNotEmpty) {
      return super.execScript(script, args);
    } else {
      return super.execScript(script, []);
    }
  }
}
