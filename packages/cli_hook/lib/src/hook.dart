import 'dart:collection';

import 'package:tuple/tuple.dart';

abstract class Hook {
  Future<void> run(Iterable<String> args);

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

  static Tuple3<Tuple2<Hook, List<String>>?, Tuple2<Hook, List<String>>?,
      Tuple2<Hook, List<String>>?> lookup({
    required Iterable<String> commands,
    required Map<String, Hook> hooks,
    String separator = ':',
  }) {
    var args = <String>[];
    final cmds = Queue.of(commands);
    Tuple2<Hook, List<String>>? pre, command, post;
    while (cmds.isNotEmpty) {
      final hookName = cmds.join(separator);
      if (command == null && hooks[hookName] != null) {
        command = Tuple2<Hook, List<String>>(hooks[hookName]!, [...args]);
      }
      final preHookName = ['pre', hookName].join(separator);
      if (pre == null && hooks[preHookName] != null) {
        pre = Tuple2<Hook, List<String>>(hooks[preHookName]!, [...args]);
      }
      final postHookName = ['post', hookName].join(separator);
      if (post == null && hooks[postHookName] != null) {
        post = Tuple2<Hook, List<String>>(hooks[postHookName]!, [...args]);
      }
      args.insert(0, cmds.removeLast());
    }
    return Tuple3<Tuple2<Hook, List<String>>?, Tuple2<Hook, List<String>>?,
        Tuple2<Hook, List<String>>?>(pre, command, post);
  }
}
