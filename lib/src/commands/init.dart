import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

class InitCommand extends Command {
  @override
  String get description => 'Init project.';

  @override
  String get name => 'init';

  @override
  Future<void> run() async {
    var file = File(join(Directory.current.path, 'flutterw.yaml'));
    if (!file.existsSync()) {
      file.createSync();
    }
  }
}
