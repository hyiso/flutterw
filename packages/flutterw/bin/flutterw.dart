import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:flutterw/runner.dart';
import 'package:flutterw/version.g.dart';

void main(List<String> args) async {
  var runner = FlutterWrapperRunner();
  if (args.contains('--version')) {
    stderr.writeln('Flutterw $kPackageVersion');
  }
  runner.run(args).catchError((e) {
    stderr.writeln(Colorize(e.toString()).red());
  });
}
