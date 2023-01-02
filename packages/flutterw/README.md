# Intruction
`flutterw` wraps flutter tool with more advanced usage.

## Features 
* Basiclly supports all flutter commands.
* Command hooks

## Getting Started

Install the latest `flutterw` version as a global package via [Pub](https://pub.dev/).

```bash
dart pub global activate flutterw

# Or
# flutter pub global activate flutterw
```

## Usage

Just use `flutterw` as `flutter` tool.

i.e:
``` shell
  flutterw clean
  flutterw pub get
  ...
```

### Hooks

Adding command hooks in `flutterw.yaml` can automatically do extra works.
``` yaml
hooks:
  pre_clean:
    - echo 'task 1'
    - echo 'task 2'
  post_clean:
    - echo 'task 3'
    - echo 'task 4'
```

#### Add Package Hook

You can add a package hook to global or project.

First, activate a package globally

``` shell
dart pub global activate flutterw_clean
```

Then, add it to flutterw global hook.
``` shell
flutterw hook add clean flutterw_clean -g
```

Finallym, run `flutterw clean` to see output message.
