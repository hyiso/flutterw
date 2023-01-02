import 'dart:async';
import 'dart:collection';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:tuple/tuple.dart';

import 'hook.dart';
import 'runner.dart';

class WrapperCommand<T> extends Command<T> {
  @override
  String get description => 'Wrapped $name command.';

  @override
  final String name;

  final bool isLeaf;

  WrapperCommand({
    this.name = '',
    this.isLeaf = true,
  }) : super();

  @override
  ArgParser get argParser =>
      isLeaf ? ArgParser.allowAnything() : super.argParser;

  List<String> get commandList {
    final cmds = <String>[];
    Command? command = this;
    while (command != null) {
      cmds.insert(0, command.name);
      command = command.parent;
    }
    return cmds;
  }

  @override
  FutureOr<T>? run() async {
    final pre = lookupHook('pre_');
    if (pre != null) {
      await pre.item1.run([...pre.item2, ...argResults!.arguments]);
    }
    final it = lookupHook();
    if (it != null) {
      await it.item1.run([...it.item2, ...argResults!.arguments]);
    } else {
      await (runner! as WrapperRunner)
          .runOrigin([...commandList, ...argResults!.arguments]);
    }
    final post = lookupHook('post_');
    if (post != null) {
      await post.item1.run([...post.item2, ...argResults!.arguments]);
    }
    return Future.value();
  }

  ///
  /// Search pref_command_subcommand(_leaf)
  /// Then fallback to pref_command(_subcommand)
  /// Until prefix.
  ///
  /// When fallback to upper key, join unused parts as arguments.
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
  Tuple2<Hook, Iterable<String>>? lookupHook([String? prefix]) {
    var args = <String>[];
    final cmds = Queue.of(commandList);
    final hooks = (runner as WrapperRunner).hooks;
    while (cmds.isNotEmpty) {
      var hookName = cmds.join('_').replaceAll('-', '_');
      if (prefix?.isNotEmpty == true) {
        hookName = [prefix, hookName].join();
      }
      if (hooks[hookName] != null) {
        return Tuple2<Hook, Iterable<String>>(hooks[hookName]!, args);
      }
      args.insert(0, cmds.removeLast());
    }
    return null;
  }
}
