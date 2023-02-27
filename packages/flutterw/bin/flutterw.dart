import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:flutterw/flutterw.dart';

Future<void> main(List<String> args) async {
  final file = File('pubspec.yaml');
  final config = file.existsSync()
      ? FlutterwConfig.fromFile(file)
      : FlutterwConfig.empty();
  await FlutterwRunner(scripts: config.scripts, logger: Logger.standard())
      .run(args);
}
