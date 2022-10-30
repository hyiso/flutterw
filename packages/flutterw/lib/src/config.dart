import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

const kFlutterwConfigFileName = 'flutterw.yaml';

class Config {


  Config.fromFile(this.file);

  File file;

  YamlMap? get _config => loadYaml(file.readAsStringSync());

  
  dynamic operator [](Object? key) => _config?[key];

  static Config? lookup(Directory directory) {
    for (var dir = directory; dir.path != dir.parent.path; dir = dir.parent) {
      var file = File(join(dir.path, kFlutterwConfigFileName));
      if (file.existsSync()) {
        return Config.fromFile(file);
      }
    }
    return null;
  }

}