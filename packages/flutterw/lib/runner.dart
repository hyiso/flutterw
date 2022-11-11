import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:yaml/yaml.dart';

import 'src/commands/help.dart';
import 'src/commands/wrapper.dart';

const kConfigFileName = 'flutterw.yaml';

class FlutterWrapperRunner extends WrapperRunner {
  FlutterWrapperRunner()
      : super(
          'flutterw',
          'flutter',
        );

  @override
  String get description => 'flutterw wraps flutter tool with advanced usage.';

  YamlMap? get config {
    final file = File(kConfigFileName);
    if (file.existsSync()) {
      return loadYaml(file.readAsStringSync());
    }
    return null;
  }

  @override
  String get originExecutable => config?[originName] ?? originName;

  @override
  void addCommand(Command command) {
    if (command.name == 'help') {
      super.addCommand(HelpCommand(originExecutable: originExecutable));
    } else {
      super.addCommand(FlutterWrapperCommand(
          name: command.name, originExecutable: originExecutable));
    }
  }

  @override
  String get usage {
    var buffer = StringBuffer('$description\n\n');
    final process = Process.runSync(originExecutable, ['-h']);
    buffer.write((process.stderr as String?)
        ?.replaceAll(originExecutable, executableName));
    buffer.write((process.stdout as String?)
        ?.replaceAll(originExecutable, executableName));
    return buffer.toString();
  }
}
