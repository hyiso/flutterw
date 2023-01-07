


import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';

class TestRunner extends CommandRunner with WrapperRunner {
  
  TestRunner() : super('test', 'test');
  
  @override
  String get originExecutableName => 'test';

  bool _runingOrigin = false;
  bool get isRuningOrigin => _runingOrigin;

  Iterable<String> ?_arguments;
  Iterable<String>? get arguments => _arguments;

  @override
  Future<void> runOrigin(List<String> arguments) async {
    _runingOrigin = true;
    _arguments = arguments;
  }

  @override
  Command createCommand(String name) => TestCommand(name);

}

class TestCommand extends WrapperCommand {
  TestCommand(String name) : super(name);

  bool _runing = false;

  bool get isRuning => _runing;

  @override
  FutureOr? run() {
    _runing = true;
    return super.run();
  }

}