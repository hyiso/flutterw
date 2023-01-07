import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'runner.dart';

class ParentCommand<T> extends Command<T> {
  @override
  String get description => 'Wrapped $name command.';

  @override
  final String name;

  ParentCommand(this.name) : super();

}

class WrapperCommand<T> extends Command<T> {
  @override
  String get description => 'Wrapped $name command.';

  @override
  final String name;

  WrapperCommand(this.name) : super();

  @override
  ArgParser get argParser => ArgParser.allowAnything();

  List<String> get stacks {
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
    await (runner! as WrapperRunner).runOrigin([...stacks, ...argResults!.arguments]);
    return Future.value(null);
  }
}