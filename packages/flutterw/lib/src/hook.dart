import 'package:cli_wrapper/cli_wrapper.dart';

extension _PackageName on String {
  String toCmd(bool global) => [
        'flutter', 'pub',
        if (global) 'global',
        'run', this,
      ].join(' ');
}

class FlutterWrapperHook extends Hook {
  @override
  final String name;

  @override
  final List<String> scripts;

  FlutterWrapperHook.fromScripts({
    required this.name,
    required this.scripts,
  });

  FlutterWrapperHook.fromPackage({
    required this.name,
    required String package,
    bool global = false,
  }) : scripts = [package.toCmd(global)];
}
