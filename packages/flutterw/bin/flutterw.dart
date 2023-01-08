import 'dart:io';

import 'package:flutterw/flutterw.dart';

void main(List<String> args) {
  final file = File('flutterw.yaml');
  final config = file.existsSync()
      ? FlutterwConfig.fromFile(file)
      : FlutterwConfig.empty();
  FlutterwRunner(config: config).run(args);
}
