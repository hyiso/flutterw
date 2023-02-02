import 'dart:io';

import 'package:cli_hook/cli_hook.dart';
import 'package:cli_util/cli_logging.dart';

import 'logger.dart';

/// Script needs args can add this placeholder.
const _kArgsPlaceholder = '<args>';

/// ScriptHook
///
/// A hook can be a list of executable scripts
///
class ScriptHook extends Hook {
  final String name;

  final List<String> scripts;

  final Logger logger;

  ScriptHook({
    required this.name,
    required List<String> scripts,
    required this.logger,
  }) : scripts = scripts.map((e) => e.trim()).toList();

  @override
  Future<void> run(List<String> args) async {
    logger.name(name);

    /// Assume -v,--verbose is mostly placed end of args,
    /// search it from end to start
    var verboseIndex = -1;
    for (var i = args.length - 1; i >= 0; i--) {
      if (args[i] == '--verbose' || args[i] == '-v') {
        verboseIndex = i;
        break;
      }
    }
    for (String script in scripts) {
      await execScript(script, args, verbose: verboseIndex != -1);
    }
  }

  /// Replace [_kArgsPlaceholder] in script to args,
  /// then execute this script.
  Future<void> execScript(String script, List<String> args,
      {bool verbose = false}) async {
    final segments = script.split(RegExp(r'\s+'));

    /// Assume <args> is mostly placed end of script,
    /// search it from end to start
    var argsIndex = -1;
    var verboseIndex = -1;
    for (var i = segments.length - 1; i >= 0; i--) {
      if (segments[i] == _kArgsPlaceholder) {
        argsIndex = i;
      }
      if (segments[i] == '--verbose' || segments[i] == '-v') {
        verboseIndex = i;
      }
      if (argsIndex != -1 && verboseIndex != -1) {
        break;
      }
    }

    /// Replace the <args> palceholder with runtime args.
    if (argsIndex != -1) {
      segments.replaceRange(argsIndex, argsIndex + 1, args);
    }
    final isVerbose = verbose || verboseIndex != -1;
    logger.script(segments.join(' '), isVerbose);
    final process = await Process.start(
      segments.removeAt(0),
      segments,
      mode: isVerbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    final code = await process.exitCode;
    logger.result(code == 0);
    if (code != 0) {
      exit(code);
    }
  }

  static Map<String, ScriptHook> transform(
      Map<String, dynamic> scripts, Logger logger) {
    if (scripts.isEmpty) {
      return {};
    }
    return scripts.map<String, ScriptHook>((key, value) {
      if (value is List) {
        return MapEntry(
            key,
            ScriptHook(
              name: key,
              logger: logger,
              scripts: value.cast(),
            ));
      } else {
        return MapEntry(
            key,
            ScriptHook(
              name: key,
              logger: logger,
              scripts: (value as String).split('&&'),
            ));
      }
    });
  }
}
