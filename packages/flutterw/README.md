# Intruction
`flutterw` wraps flutter tool with more advanced usage.

## Features 
* Basiclly supports all flutter commands.
* Located flutter tool.
* Command hooks

## Getting Started

Install the latest `flutterw` version as a global package via [Pub](https://pub.dev/).

```bash
dart pub global activate flutterw

# Or alternatively to specify a specific version:
# pub global activate flutterw 0.3.0
```

## Usage

Just use `flutterw` as `flutter` tool.

i.e:
``` shell
  flutterw clean
  flutterw pub get
  ...
```

### Command Hooks

Adding command hooks in `flutterw.yaml` can automatically do extra works.
``` yaml
hooks:
  pre_flutter_clean:
    - echo 'task 1'
    - echo 'task 2'
  post_flutter_pub_get:
    - echo 'task 3'
    - echo 'task 4'
```