import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';

void main(List<String> arguments) async {
  final pubspec = await PubSpec.load(Directory.current);
  final gradle = 'package:flutterw_build_aar/gradle/aar.gradle';
  final uri = await Isolate.resolvePackageUri(Uri.parse(gradle));
  if (uri != null) {
    final apply = 'apply from: \'$uri\'';
    final buildGradleFile =
        File(join(Directory.current.path, '.android', 'build.gradle'));
    final lines = await buildGradleFile.readAsLines();
    if (!lines.last.contains(apply)) {
      await buildGradleFile.writeAsString('\n$apply', mode: FileMode.append);
    }
  }
  final index = arguments.indexOf('--build-number');
  if (index == -1) {
    arguments.addAll(['--build-number', pubspec.version!.canonicalizedVersion]);
  } else {
    arguments.replaceRange(
        index + 1, index + 2, [pubspec.version!.canonicalizedVersion]);
  }
  final process = await Process.start('flutter', ['build', 'aar', ...arguments],
      mode: ProcessStartMode.inheritStdio);
  exitCode = await process.exitCode;
}
