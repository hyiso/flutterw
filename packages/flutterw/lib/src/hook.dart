import 'dart:io';

import 'package:cli_hook/cli_hook.dart';

/// Hook scripts that need args can add this placeholder.
const kFlutterwHookArgsPlaceholder = '<args>';

/// Fluttew Hook
///
/// A hook can be a list of scripts,
/// or a dart package.
///
class FlutterwHook extends Hook {
  final String name;

  final List<String> scripts;

  FlutterwHook.fromScripts({
    required this.name,
    required this.scripts,
  }) : verbose = false;

  final bool verbose;

  FlutterwHook.fromPackage({
    required this.name,
    required String package,
    bool global = false,
  })  : verbose = true,
        scripts = [
          [
            'flutter',
            'pub',
            if (global) 'global',
            'run',
            package,
            kFlutterwHookArgsPlaceholder,
          ].join(' ')
        ];

  @override
  Future<void> run(Iterable<String> args) async {
    stderr.writeln('Run hook $name');
    for (String script in scripts) {
      await execScript(script, args);
    }
  }

  /// Replace [kFlutterwHookArgsPlaceholder] in script to args,
  /// then execute this script.
  Future<void> execScript(String script, Iterable<String> args) async {
    stderr.writeln('  └> $script');
    final segments = script.split(RegExp(r'\s+'));

    /// Assume <args> is offen at end of script,
    /// search it from end to start
    var argsIndex = -1;
    for (var i = segments.length - 1; i >= 0; i--) {
      if (segments[i] == kFlutterwHookArgsPlaceholder) {
        argsIndex = i;
        break;
      }
    }

    /// Replace the
    if (argsIndex != -1) {
      segments.replaceRange(argsIndex, argsIndex + 1, args);
    }
    final process = await Process.start(
      segments.removeAt(0),
      segments,
      mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
  }
}
