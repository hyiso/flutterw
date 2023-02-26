import 'package:cli_util/cli_logging.dart';

extension FlutterwLogging on Logger {
  void script(String name, dynamic value) {
    stderr(ansi.emphasized('${ansi.yellow}$name${ansi.none}'));
    if (value is String) {
      stderr(ansi.emphasized('  └> ${ansi.cyan}$value${ansi.none}'));
    } else if (value is List) {
      for (var item in value) {
        stderr(ansi.emphasized('  └> ${ansi.cyan}$item${ansi.none}'));
      }
    }
  }

  void shell(String shell, bool isVerbose) {
    if (isVerbose) {
      stderr(ansi.emphasized('${ansi.cyan}$shell${ansi.none}'));
    } else {
      progress(ansi.emphasized('${ansi.cyan}$shell${ansi.none}'));
    }
  }

  void result(bool success) {
    if (success) {
      stderr(ansi.emphasized('  └> ${ansi.green}SUCCESS${ansi.none}'));
    } else {
      stderr(ansi.emphasized('  └> ${ansi.red}FAILED${ansi.none}'));
    }
  }
}
