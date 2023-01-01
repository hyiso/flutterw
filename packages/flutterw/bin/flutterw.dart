import 'dart:io';

import 'package:flutterw/runner.dart';
import 'package:flutterw/src/logger.dart';
import 'package:flutterw/version.g.dart';

void main(List<String> args) async {
  var runner = FlutterWrapperRunner();
  if (args.contains('--version')) {
    stderr.writeln('Flutterw $kPackageVersion');
  }
  initLogger(false);
  runner.run(args).catchError((e, stack) {
    logError(e.toString());
    logError(stack.toString());
  });
}
