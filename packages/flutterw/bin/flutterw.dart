import 'package:cli_wrapper/cli_wrapper.dart';
import 'package:flutterw/flutterw.dart';

void main(List<String> args) {
  final hooks = projectConfig.hooks.map<String, Hook>((key, value) {
    if (value is List) {
      return MapEntry(
          key,
          FlutterWrapperHook.fromScripts(
            name: key,
            scripts: value.cast(),
          ));
    } else {
      return MapEntry(
          key, FlutterWrapperHook.fromPackage(name: key, package: value));
    }
  });
  FlutterWrapperRunner(hooks).run(args);
}
