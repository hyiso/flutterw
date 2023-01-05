## About

This is a hook package for [flutterw](../flutterw), the usage is to manage package hooks.

## Install

First, add this package in `dev_dependencies` in project's `pubspec.yaml`.
```yaml
dev_dependencies:
  flutterw_hook: any
```
Then, add this package to `hooks` in project's `flutterw.yaml`.
```yaml
hooks:
  hook: flutterw_hook
```
Now, you can run `flutterw hook <subcommand> [arguemnts]` to manage hooks.

## Manage Hooks

Shell scripts hooks can be managed by modifying project's `flutterw.yaml`

Package hooks can be managed by using `flutterw hook <subcommand> [arguemnts]`.

```
> flutterw hook -h

Manage Flutterw Hooks.

Usage: flutterw hook <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  add      Add a hook
  list     List all hooks
  remove   Remove a hook

Run "flutterw help hook" to see global options.
```
