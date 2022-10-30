import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:flutterw/runner.dart';

void main(List<String> args) {
  var runner = WrapperRunner('dart');
  runner.run(args).catchError((e) {
    stderr.writeln(Colorize(e.toString()).red());
  });
}
