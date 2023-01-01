///
/// Search wrapper_command_subcommand(_leaf)
/// Then fallback to wrapper_command(_subcommand)
/// Until prefix.
///
/// When hits a plugin, join un-hitted parts as arguments.
///
/// For example:
///   wrapper is foow
///   command is foow bar baz qux -a v -b balabala
/// Then
///   commands is ['bar', 'baz', 'qux']
///
/// Assume prefix is foow_plugin_
///
/// Search order would be:
///   foow_plugin_bar_baz_qux
///   foow_plugin_bar_baz
///   foow_plugin_bar
/// If hits any of them, then return value correspondingly:
///   ['foow_plugin_bar_baz_qux']
///   ['foow_plugin_bar_baz', 'qux']
///   ['foow_plugin_bar', 'baz', 'qux']
List<String>? lookupPluginCommand(Map plugins, Iterable<String> commands,
    [String? prefix]) {
  var usedCommands = [...commands];
  var unusedCommands = [];
  while (usedCommands.isNotEmpty) {
    var plugin = usedCommands.join('_').replaceAll('-', '_');
    if (prefix != null) {
      plugin = [prefix, plugin].join();
    }
    if (plugins[plugin] != null) {
      return [plugin, ...unusedCommands];
    }
    unusedCommands.insert(0, usedCommands.removeLast());
  }
  return null;
}
