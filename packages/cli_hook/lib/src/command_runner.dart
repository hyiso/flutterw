import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'hook.dart';

///
/// [CommandRunner] that support hooks must use this mixin.
/// And provides supported [hooks] map.
///
mixin HookRunner<T> on CommandRunner<T> {
  /// Hooks Map
  /// This map will be used for command to lookup pre, post and replacement hooks.
  /// override this to provide supported hooks.
  Map<String, Hook> get hooks;

  @override
  Future<T?> runCommand(ArgResults topLevelResults) async {
    // No arguments or contains -h,--help
    if (topLevelResults.arguments.isEmpty ||
        topLevelResults.arguments.contains('-h') ||
        topLevelResults.arguments.contains('--help')) {
      return super.runCommand(topLevelResults);
    }
    final commands = <String>[];
    List<String> args = [];
    for (var i = 0; i < topLevelResults.arguments.length; i++) {
      final condidate = topLevelResults.arguments.elementAt(i);
      if (invalid(condidate)) {
        args = topLevelResults.arguments.sublist(i);
        break;
      }
      commands.add(condidate);
    }
    final commandHooks = Hook.lookup(
      commands: commands,
      hooks: hooks,
    );
    final pre = commandHooks.item1;
    if (pre != null) {
      await pre.item1.run([...pre.item2, ...args]);
    }
    final replacement = commandHooks.item2;
    T? result;
    if (replacement != null) {
      await replacement.item1.run([...replacement.item2, ...args]);
    } else {
      result = await super.runCommand(topLevelResults);
    }
    final post = commandHooks.item3;
    if (post != null) {
      await post.item1.run([...post.item2, ...args]);
    }
    return result;
  }

  /// Invalid for hook name part.
  bool invalid(String name) {
    return name.startsWith('-') || name.contains('.') || name.contains('/');
  }
}
