import 'dart:io';

import 'package:colorize/colorize.dart';

import 'runner.dart';

Future<void> main(List<String> args) async {
  var runner = FlutterwRunner();
  await runner.run(args).catchError((e) {
    stderr.writeln(Colorize(e.toString()).red());
  });
}
