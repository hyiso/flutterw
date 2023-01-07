import 'dart:collection';
import 'dart:io';

import 'package:tuple/tuple.dart';

abstract class Hook {
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

  ///
  /// Search Command Hooks
  ///
  /// if commands is ['foo', 'bar', 'baz', 'qux', 'fred']
  ///
  /// search order
  ///   - (pre|post:)foo:bar:baz:qux(:fred)
  ///   - (pre|post:)foo:bar:baz(:qux)
  ///   - (pre|post:)foo:bar(:baz)
  /// Until (pre|post:)foo.
  ///
  /// When search fallback, set unused parts as arguments.
  ///
  /// For example:
  ///   commands is ['foo', 'bar', 'baz']
  ///   prefix is pre_
  ///
  /// Search order would be:
  ///   pre_foo_bar_baz
  ///   pre_foo_bar
  ///   pre_foo
  ///
  /// If hits any of them, then return pair of the hook and unused arguments.
  ///

  static CommandHooks lookup({
    required Iterable<String> commands,
    required Map<String, Hook> hooks,
    String separator = ':',
  }) {
    var args = <String>[];
    final cmds = Queue.of(commands);
    HookArgs? pre, command, post;
    while (cmds.isNotEmpty) {
      final hookName = cmds.join(separator);
      if (command == null && hooks[hookName] != null) {
        command = HookArgs(hooks[hookName]!, [...args]);
      }
      final preHookName = ['pre', hookName].join(separator);
      if (pre == null && hooks[preHookName] != null) {
        pre = HookArgs(hooks[preHookName]!, [...args]);
      }
      final postHookName = ['post', hookName].join(separator);
      if (post == null && hooks[postHookName] != null) {
        post = HookArgs(hooks[postHookName]!, [...args]);
      }
      args.insert(0, cmds.removeLast());
    }
    return CommandHooks(pre, command, post);
  }
}

/// Hook and arguments.
typedef HookArgs = Tuple2<Hook, List<String>>;

typedef CommandHooks = Tuple3<HookArgs?, HookArgs?, HookArgs?>;
