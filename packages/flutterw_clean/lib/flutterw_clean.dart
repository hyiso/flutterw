import 'dart:io';

import 'package:path/path.dart';

extension EntryDirectory on Directory {
  Directory childDirectory(String name) {
    return Directory(join(path, name));
  }
  File childFile(String name) {
    return File(join(path, name));
  }
}

void clean(Directory projectDir, List<String> entries) {
  for (var entry in entries) {
    if (entry.endsWith('/')) {
      Directory dir = projectDir.childDirectory(entry);
      if (dir.existsSync()) {
        stderr.writeln('Deleting ${entry.substring(0, entry.length - 1)}...');
        dir.deleteSync(recursive: true);
      }
    } else {
      File file = projectDir.childFile(entry);
      if (file.existsSync()) {
        stderr.writeln('Deleting $entry...');
        file.deleteSync();
      }
    }
  }

}