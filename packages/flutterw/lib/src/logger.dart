import 'package:cli_util/cli_logging.dart';

extension FlutterwLogging on Logger {
  void name(String name) {
    stderr(ansi.emphasized('${ansi.yellow}$name${ansi.none}'));
  }

  void script(String script, bool isVerbose) {
    if (isVerbose) {
      stderr(ansi.emphasized('  └> ${ansi.cyan}$script${ansi.none}'));
    } else {
      progress(ansi.emphasized('  └> ${ansi.cyan}$script${ansi.none}'));
    }
  }

  void result(bool success) {
    if (success) {
      stderr(ansi.emphasized('    └> ${ansi.green}SUCCESS${ansi.none}'));
    } else {
      stderr(ansi.emphasized('    └> ${ansi.red}FAILED${ansi.none}'));
    }
  }
}
