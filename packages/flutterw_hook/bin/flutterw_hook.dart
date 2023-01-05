import 'package:args/command_runner.dart';
import 'package:flutterw_hook/flutterw_hook.dart';

void main(List<String> arguments) {
  CommandRunner('flutterw hook', 'Manage Flutterw Hooks')
    ..addCommand(HookAddCommand())
    ..addCommand(HookListCommand())
    ..addCommand(HookRemoveCommand())
    ..run(arguments);
}
