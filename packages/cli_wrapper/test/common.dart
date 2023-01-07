import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';

class TestRunner extends CommandRunner with WrapperRunner {
  TestRunner() : super('test', 'test');

  @override
  String get originExecutableName => 'test';

  bool _originTriggered = false;
  bool get isOriginTriggered => _originTriggered;

  Iterable<String>? _runOriginArguments;
  Iterable<String>? get runOriginArguments => _runOriginArguments;

  @override
  Future<void> runOrigin(List<String> arguments) async {
    _originTriggered = true;
    _runOriginArguments = arguments;
  }

  bool _printUsageCalled = false;
  bool get isPrintUsageCalled => _printUsageCalled;

  @override
  void printUsage() {
    _printUsageCalled = true;
    super.printUsage();
  }
}

class TestCommand extends Command {
  @override
  String get description => 'command $name';

  @override
  final String name;

  TestCommand(this.name);

  bool _printUsageCalled = false;
  bool get isPrintUsageCalled => _printUsageCalled;

  @override
  void printUsage() {
    _printUsageCalled = true;
    super.printUsage();
  }

  bool _trigger = false;
  bool get isTriggered => _trigger;

  @override
  Future<void> run() async {
    _trigger = true;
  }
}
