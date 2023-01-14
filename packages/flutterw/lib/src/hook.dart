import 'dart:io';

import 'package:cli_hook/cli_hook.dart';

/// Script needs args can add this placeholder.
const _kArgsPlaceholder = '<args>';

/// ScriptHook
///
/// A hook can be a list of executable scripts
///
class ScriptHook extends Hook {
  final String name;

  final List<String> scripts;

  ScriptHook({
    required this.name,
    required List<String> scripts,
  }) : scripts = scripts.map((e) => e.trim()).toList();

  @override
  Future<void> run(Iterable<String> args) async {
    stderr.writeln('Running $name script');
    for (String script in scripts) {
      await execScript(script, args);
    }
  }

  /// Replace [_kArgsPlaceholder] in script to args,
  /// then execute this script.
  Future<void> execScript(String script, Iterable<String> args) async {
    final segments = script.split(RegExp(r'\s+'));

    /// Assume <args> is placed end of this script,
    /// search it from end to start
    var argsIndex = -1;
    for (var i = segments.length - 1; i >= 0; i--) {
      if (segments[i] == _kArgsPlaceholder) {
        argsIndex = i;
        break;
      }
    }

    /// Replace the <args> palceholder with runtime args.
    if (argsIndex != -1) {
      segments.replaceRange(argsIndex, argsIndex + 1, args);
    }
    final process = await Process.start(
      segments.removeAt(0),
      segments,
    );
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
  }

  static Map<String, ScriptHook> transform(Map<String, dynamic> scripts) {
    if (scripts.isEmpty) {
      return {};
    }
    return scripts.map<String, ScriptHook>((key, value) {
      if (value is List) {
        return MapEntry(
            key,
            ScriptHook(
              name: key,
              scripts: value.cast(),
            ));
      } else {
        return MapEntry(
            key,
            ScriptHook(
              name: key,
              scripts: (value as String).split('&&'),
            ));
      }
    });
  }
}
