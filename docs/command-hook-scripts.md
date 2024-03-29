# Command-Hook-Script

A command-hook-script is a script with name of flutter builtin commands. For example: 

```yaml
scripts:
  clean: flutter pub run flutterw_clean
```
When running `flutterw clean`, `flutter pub run flutterw_clean` will be executed instead.

## Pre & Post Command Hook Script

Each Flutter command can be hooked with `pre:command` and `post:comand`:

```yaml
scripts:
  pre:clean: echo 'pre clean'
  post:clean: echo 'post clean'
```
When running `flutterw clean`, `pre:clean` will be executed first, then the `clean` command runs,
and `post:clean` will be executed finally.

## Sub Command Hook

For sub command, hook name is command parts joined with colon(`:`)

```yaml
scripts:
  pre:build:aar: # This is pre hook for 'flutterw build aar'
  build:aar: # This is command hook 'flutterw build aar'
  post:build:aar: # This is post hook for 'flutterw build aar'
```

# Script Args

Scripts don't take arguments from running command by default.

If a command hook script needs to use the command arguments, use a `<args>` placeholder.

For example:

```yaml
scripts:
  pre:build:
    - dart ./scripts/pre_build.dart <args> # arguments passed to build command will be here.
  post:build:
    - dart ./scripts/post_build.dart <args> # arguments passed to build command will be here.
```