class WrapperArgResults {
  final Iterable<String> arguments;
  final Iterable<String> rest;

  final Iterable<String> commands;

  WrapperArgResults._({
    required this.commands,
    required this.arguments,
    required this.rest,
  });

  WrapperArgResults copyWithPluginPrefix(String pluginPrefix) {
    return WrapperArgResults._(
      commands: commands,
      arguments: arguments,
      rest: rest,
    );
  }

  String get underlineCommand => commands.join('_').replaceAll('-', '_');
}

class WrapperArgParser {
  final List<String> _commands = [];

  /// The arguments being parsed.
  List<String> _args = [];

  final Map<String, dynamic> _flagsAndOptions = {};

  /// The current argument being parsed.
  String get _current => _args.first;

  WrapperArgParser();

  WrapperArgResults parse(Iterable<String> args) {
    _args = [...args];
    _commands.clear();
    _flagsAndOptions.clear();
    var rest = <String>[];

    // Parse the args.
    while (_args.isNotEmpty) {
      if (_current == '--') {
        // Reached the argument terminator, so stop here.
        _args.removeAt(0);
        break;
      }

      if (_parseSubCommand()) continue;
      // Try to parse the current argument as an option. Note that the order
      // here matters.
      if (_parseSoloFlogOrOption()) continue;
      if (_parseLongFlagOrOption()) continue;
      rest.add(_args.removeAt(0));
    }

    // Add in the leftover arguments we didn't parse to the innermost command.
    rest.addAll(_args);
    _args.clear();
    return WrapperArgResults._(
      commands: _commands,
      arguments: args.skip(_commands.length),
      rest: rest,
    );
  }

  bool _parseSubCommand() {
    if (_current.isEmpty) return false;
    if (_current.startsWith('-')) return false;

    /// Assume argument after option and flag is positioned argument.
    if (_flagsAndOptions.isNotEmpty) return false;
    _commands.add(_args.removeAt(0));
    return true;
  }

  /// Pulls the value for [option] from the second argument in [_args].
  ///
  /// Validates that there is a valid value there.
  void _readNextArgAsValue(String option) {
    _setOption(option, _args.removeAt(0));
  }

  /// Tries to parse the current argument as a "solo" option, which is a single
  /// hyphen followed by a single letter.
  ///
  /// We treat this differently than collapsed abbreviations (like "-abc") to
  /// handle the possible value that may follow it.
  bool _parseSoloFlogOrOption() {
    // Hand coded regexp: r'^-([a-zA-Z0-9])$'
    // Length must be two, hyphen followed by any letter/digit.
    if (_current.length != 2) return false;
    if (!_current.startsWith('-')) return false;
    var opt = _current[1];
    if (!_isLetterOrDigit(opt.codeUnitAt(0))) return false;
    return _handleSoloFlagOrOption(opt);
  }

  bool _handleSoloFlagOrOption(String opt) {
    _args.removeAt(0);
    if (_args.isNotEmpty && _current.startsWith('-')) {
      _setFlag(opt, true);
    } else if (_args.isNotEmpty) {
      _readNextArgAsValue(opt);
    }

    return true;
  }

  /// Tries to parse the current argument as a long-form named option, which
  /// may include a value like "--mode=release" or "--mode release".
  bool _parseLongFlagOrOption() {
    // Hand coded regexp: r'^--([a-zA-Z\-_0-9]+)(=(.*))?$'
    // Two hyphens then at least one letter/digit/hyphen, optionally an equal
    // sign followed by zero or more anything-but-newlines.

    if (!_current.startsWith('--')) return false;

    var index = _current.indexOf('=');
    var name =
        index == -1 ? _current.substring(2) : _current.substring(2, index);
    for (var i = 0; i != name.length; ++i) {
      if (!_isLetterDigitHyphenOrUnderscore(name.codeUnitAt(i))) return false;
    }
    var value = index == -1 ? null : _current.substring(index + 1);
    if (value != null && (value.contains('\n') || value.contains('\r'))) {
      return false;
    }
    return _handleLongOption(name, value);
  }

  bool _handleLongOption(String name, String? value) {
    if (!name.startsWith('no-')) {
      _args.removeAt(0);
      if (_args.isNotEmpty && _current.startsWith('-')) {
        _setFlag(name, true);
      } else if (value != null) {
        // We have a value like --foo=bar.
        _setOption(name, value);
      } else if (_args.isNotEmpty) {
        // Option like --foo, so look for the value as the next arg.
        _readNextArgAsValue(name);
      }
    } else {
      // See if it's a negated flag.
      var positiveName = name.substring('no-'.length);
      _args.removeAt(0);
      _setFlag(positiveName, false);
    }

    return true;
  }

  /// Validates and stores [value] as the value for [option], which must not be
  /// a flag.
  void _setOption(String option, String value) {
    if (!value.contains(',')) {
      _flagsAndOptions[option] = value;
      return;
    }

    List<String> list = _flagsAndOptions.putIfAbsent(option, () => <String>[]);

    for (var element in value.split(',')) {
      list.add(element);
    }
  }

  /// Validates and stores [value] as the value for [flag], which must be a
  /// flag.
  void _setFlag(String flag, bool value) {
    _flagsAndOptions[flag] = value;
  }
}

bool _isLetterOrDigit(int codeUnit) =>
    // Uppercase letters.
    (codeUnit >= 65 && codeUnit <= 90) ||
    // Lowercase letters.
    (codeUnit >= 97 && codeUnit <= 122) ||
    // Digits.
    (codeUnit >= 48 && codeUnit <= 57);

bool _isLetterDigitHyphenOrUnderscore(int codeUnit) =>
    _isLetterOrDigit(codeUnit) ||
    // Hyphen.
    codeUnit == 45 ||
    // Underscore.
    codeUnit == 95;
