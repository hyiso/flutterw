import 'dart:io';

void main(List<String> arguments) {
  Process.start(
    'flutter',
    ['clean'],
    mode: ProcessStartMode.inheritStdio,
  );
}
