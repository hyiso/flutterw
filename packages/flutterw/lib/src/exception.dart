class ScriptException implements Exception {
  final String name;

  final dynamic message;

  ScriptException(this.name, [this.message]);

  @override
  String toString() {
    if (message == null) return "ScriptException($name)";
    return "ScriptException($name): $message";
  }
}
