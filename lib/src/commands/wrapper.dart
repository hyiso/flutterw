import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'base.dart';

class WrapperCommand extends BaseCommand {

  @override
  String get description => 'Wraps $name command';

  @override
  final String name;

  WrapperCommand(this.name):super();

  @override
  final argParser = ArgParser.allowAnything();

  @override
  bool get hidden => name == 'flutter';

  File? get flutterwYamlFile {
    for (var dir = Directory.current; dir.path != dir.parent.path; dir = dir.parent) {
      var file = File(join(dir.path, 'flutterw.yaml'));
      if (file.existsSync()) {
        return file;
      }
    }
    return null;
  }

  String? get executable {
    if (flutterwYamlFile != null && flutterwYamlFile!.existsSync()) {
      YamlMap? yaml = loadYaml(flutterwYamlFile!.readAsStringSync());
      if (yaml?[name] is String) {
        stderr.writeln('Run $name from ${yaml?[name]} set in flutterw.yaml.');
        return yaml?[name];
      }
    }
    return null;
  }

  @override
  Future<void> run() async {
    await startProcess(
      executable ?? name,
      argResults!.arguments,
    );
  }

}
