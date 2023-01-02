import 'dart:io';

abstract class Hook {
  String get name;

  List<String> get scripts;

  bool get passArg => false;

  bool get isVerbose => false;

  Future<void> run(Iterable<String> args) async {
    printHook();
    for (String script in scripts) {
      printScript(script);
      final cmds = script.split(RegExp(r'\s+'));
      final process = await Process.start(
        cmds.removeAt(0),
        [...cmds, ...args],
        mode:
            isVerbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
      );
      final code = await process.exitCode;
      if (code != 0) {
        exit(code);
      }
    }
  }

  void printHook() {
    stderr.writeln('Run hook:$name');
  }

  void printScript(String script) {
    stderr.writeln('  - $script');
  }
}
