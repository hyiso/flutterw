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
  String get originExecutableName => config?['flutter'] ?? 'flutter';

  @override
  void addCommand(Command command) {
    if (command.name == 'help') {
      super.addCommand(HelpCommand());
    } else {
      super.addCommand(FlutterWrapperCommand(name: command.name));
    }
  }

  @override
  String get usage {
    var buffer = StringBuffer('$description\n\n');
    final process = Process.runSync(originExecutableName, ['-h']);
    buffer.write(
        (process.stderr as String?)?.replaceAll('flutter', executableName));
    buffer.write(
        (process.stdout as String?)?.replaceAll('flutter', executableName));
    return buffer.toString();
  }
}
