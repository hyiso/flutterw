# Getting Started

Flutterw requires a few one-off steps to be completed before you can start using it.

## Installation

Flutterw can be installed as a global package via [pub.dev](https://pub.dev/):

```bash
dart pub global activate flutterw
```

## Setup Scripts

After installed, flutterw can be used just as flutter tool.

To use flutterw with custom scripts, just add `scripts` fields within the `pubspec.yaml` file:

```yaml
scripts:
  generate: flutter pub run build_runner build --delete-conflicting-outputs

```

Then running `flutterw generate` will execute `flutter pub run build_runner build --delete-conflicting-outputs`.

A Script's value can be multi executable string joined with `&&`, or just a spearated list.

```yaml
scripts:
  pull: git pull && git submodule update --init --recursive
```
or
```yaml
scripts:
  pull:
    - git pull
    - git submodule update --init --recursive
```
When running `flutterw pull`, this two scripts will be executable by in roder.


**Notice: scripts' names (eg: generate and pull) must not be the same with flutter command name, else they will be considered as command hook scripts.**