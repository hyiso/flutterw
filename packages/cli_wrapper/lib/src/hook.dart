import 'dart:io';

abstract class Hook {
  String get name;

  List<String> get scripts;

  bool get isVerbose => false;

  Future<void> run(Iterable<String> args) async {
    for (String script in scripts) {
      await execScript(script, args);
    }
  }

  Future<void> execScript(String script, Iterable<String> args) async {
    final cmds = script.split(RegExp(r'\s+'));
    final process = await Process.start(
      cmds.removeAt(0),
      [...cmds, ...args],
      mode: isVerbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    final code = await process.exitCode;
    if (code != 0) {
      exit(code);
    }
  }
}
