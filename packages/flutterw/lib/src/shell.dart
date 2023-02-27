import 'dart:io';

import 'package:cli_util/cli_logging.dart';

import 'logger.dart';

/// Run Flutter command.
Future<int> runFlutter(List<String> arguments) async {
  final process = await Process.start(
    'flutter',
    arguments,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) {
    exit(code);
  }
  return code;
}

/// Script needs args can add this placeholder.
const _kArgsPlaceholder = '<args>';

///
/// Run a script defined in [scripts] filed.
/// Passing the rest args to the script shells
///
/// Replace [_kArgsPlaceholder] in shell to runtime args,
/// then execute this shell.
///
Future<int> runShells(
  List<String> shells,
  List<String> args, {
  Logger? logger,
}) async {
  for (String shell in shells) {
    final cmds = buildExecutableArgs(shell, args);
    final isVerbose = args.any((arg) => ['-v', '--verbose'].contains(arg));
    logger?.shell(cmds.join(' '), isVerbose);
    final process = await Process.start(
      cmds.removeAt(0),
      cmds,
      mode: isVerbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    final code = await process.exitCode;
    if (!isVerbose) {
      logger?.result(code == 0);
    }
  }
  return 0;
}

///
/// Build executable and its arguments from given [shell] and [args]
///
/// Replace [_kArgsPlaceholder] in shell to runtime args
///
List<String> buildExecutableArgs(String shell, List<String> args) {
  final cmds = shell.split(RegExp(r'\s+'));
  int indexOfArgs = -1;

  /// Assume <args> is mostly placed end of script,
  /// search it from end to start
  for (var i = cmds.length - 1; i >= 0; i--) {
    /// Find index of [_kArgsPlaceholder] in shell
    if (cmds[i] == _kArgsPlaceholder) {
      indexOfArgs = i;
      break;
    }
  }

  /// Replace [_kArgsPlaceholder] with runtime args.
  if (indexOfArgs != -1) {
    cmds.replaceRange(indexOfArgs, indexOfArgs + 1, args);
  }
  return cmds;
}
