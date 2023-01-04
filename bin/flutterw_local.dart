import '../packages/flutterw/bin/flutterw.dart' as flutterw;

// A copy of packages/flutterw/bin/flutterw.dart
// This allows us to use flutterw on itself during development.
void main(List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    // ignore_for_file: avoid_print
    print('---------------------------------------------------------');
    print('| You are running a local development version of flutterw. |');
    print('---------------------------------------------------------');
    print('');
  }
  flutterw.main(arguments);
}
