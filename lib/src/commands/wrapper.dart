import 'dart:async';

import 'package:args/args.dart';

import 'base.dart';

class WrapperCommand extends BaseCommand {

  @override
  final String description;

  @override
  final String name;

  WrapperCommand(this.name, this.description):super();

  @override
  final argParser = ArgParser.allowAnything();

  @override
  bool get hidden => true;

  @override
  Future<void> run() async {
    await startProcess(
      'flutter',
      argResults!.arguments,
    );
  }

}
