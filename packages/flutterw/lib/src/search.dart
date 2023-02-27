import 'dart:collection';

import 'package:tuple/tuple.dart';

///
/// Search Command Hooks
///
/// if args is ['foo', 'bar', 'baz', 'qux', 'fred']
///
/// search order
///   - (pre|post:)foo:bar:baz:qux(:fred)
///   - (pre|post:)foo:bar:baz(:qux)
///   - (pre|post:)foo:bar(:baz)
/// Until (pre|post:)foo.
///
/// When search fallback, set reset parts as arguments.
///
/// For example:
///   args is ['foo', 'bar', 'baz']
///
/// Search order would be:
///   foo:bar:baz
///   foo:bar
///   foo
///
/// If hits any of them, then return pair of the hook name and reset arguments.
///
Tuple3<Tuple2<String, List<String>>?, Tuple2<String, List<String>>?,
    Tuple2<String, List<String>>?> searchCommandHooks({
  required Iterable<String> args,
  required Map<String, dynamic> scripts,
  String separator = ':',
}) {
  /// valid for hook name part.
  bool valid(String name) {
    return !name.startsWith('-') && !name.contains('.') && !name.contains('/');
  }

  final cmds = Queue.of(args.takeWhile(valid));
  final rest = List.of(args.skipWhile(valid));
  Tuple2<String, List<String>>? pre, command, post;
  while (cmds.isNotEmpty) {
    final hookName = cmds.join(separator);
    if (command == null && scripts[hookName] != null) {
      command = Tuple2<String, List<String>>(hookName, [...rest]);
    }
    final preHookName = ['pre', hookName].join(separator);
    if (pre == null && scripts[preHookName] != null) {
      pre = Tuple2<String, List<String>>(preHookName, [...rest]);
    }
    final postHookName = ['post', hookName].join(separator);
    if (post == null && scripts[postHookName] != null) {
      post = Tuple2<String, List<String>>(postHookName, [...rest]);
    }
    if (pre != null && command != null && post != null) {
      break;
    }
    rest.insert(0, cmds.removeLast());
  }
  return Tuple3<Tuple2<String, List<String>>?, Tuple2<String, List<String>>?,
      Tuple2<String, List<String>>?>(pre, command, post);
}
