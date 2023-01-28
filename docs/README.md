## Flutterw

[![Pub Version](https://img.shields.io/pub/v/flutterw?color=blue)](https://pub.dev/packages/flutterw)
[![popularity](https://img.shields.io/pub/popularity/flutterw?logo=dart)](https://pub.dev/packages/flutterw/score)
[![likes](https://img.shields.io/pub/likes/flutterw?logo=dart)](https://pub.dev/packages/flutterw/score)
[![building](https://github.com/hyiso/flutterw/actions/workflows/ci.yml/badge.svg)](https://github.com/hyiso/flutterw/actions)


> Flutterw wraps flutter tool to support scripts and command hooks.

## Why Flutterw

Flutter Tool is shipped with Flutter SDK every version with some changes. However, upgrading Flutter SDK version is not easy as projects maybe in production mode.

How to be benifited of the Flutter Tool changes without upgrading Flutter SDK is always confusing.
Also, the Flutter Tool does not give chance to do extra work during command running.

To solve these (and other related) problems, flutterw is created.

**Flutterw wraps flutter tool to support scripts and command hooks.**
**Hooks are pre, post and command scripts.**
**`pre` and `post` scripts enable you to do extra work before and after running command**
**and `command` scripts enable you to customize command behavior.**

## What can Flutterw do?

- Dispatch arguments to flutter tool when no command hook configured.
- `pre` scripts are executed before running command.
- `post` scripts are executed after running command.
- `command` scripts are executed to replace original command.
- Command scripts can be packages in [Pub](https://pub.dev/packages?q=flutterw)
  - packages created by flutterw author
    - example [flutterw_clean](https://pub.dev/packages/flutterw_clean)
  - packages created by other developers.
- Add custom to `flutterw`.

## Who's using Flutterw

The following projects are using flutterw:

- [flutterw](https://github.com/hyiso/flutterw)

> Submit a PR if you'd like to add your project to the list.
> Update the
> [docs](https://github.com/hyiso/flutterw/edit/main/docs/README.md).

## Install

```bash
dart pub global activate flutterw
```

## README Badge

Using Flutterw? Add a README badge to show it off:

[![flutterw](https://img.shields.io/badge/maintained%20with-flutterw-27b6f6.svg)](https://github.com/hyiso/flutterw)

```markdown
[![flutterw](https://img.shields.io/badge/maintained%20with-flutterw-27b6f6.svg)](https://github.com/hyiso/flutterw)
```