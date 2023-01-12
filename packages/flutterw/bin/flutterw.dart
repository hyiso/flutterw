import 'dart:io';

import 'package:flutterw/flutterw.dart';

Future<void> main(List<String> args) async {
  final file = File('flutterw.yaml');
  final config = file.existsSync()
      ? FlutterwConfig.fromFile(file)
      : FlutterwConfig.empty();
  await FlutterwRunner(config: config).run(args);
}
