import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';

import 'base.dart';

class WrapperCommand extends HookableCommand {

  @override
  String get description => 'Wraps $name command';

  @override
  final String name;

  WrapperCommand(this.name):super();

  @override
  final argParser = ArgParser.allowAnything();

  @override
  bool get hidden => true;

  String get executable {
    if (config?[name] != null) {
      stderr.writeln('Use $name located in ${config?.file.path}');
      return config?[name];
    }
    return name;
  }

  @override
  Future<int> runCommand() => startProcess(
    executable,
    argResults!.arguments,
  );

}
