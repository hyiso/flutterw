<p align="center">
  <a href="https://github.com/hyiso/flutterw">
  <img src="https://raw.githubusercontent.com/hyiso/flutterw/main/docs/./assets/flutterw-logo.png" alt="Flutterw" /> <br /><br />
  </a>
  <span>Flutterw wraps flutter tool projects to support command hook system.</span>
</p>

<p align="center">
  <a href="https://github.com/hyiso/flutterw#readme-badge"><img src="https://img.shields.io/badge/maintained%20with-flutterw-27b6f6.svg?style=flat-square" alt="Flutterw" /></a>
  <a href="https://github.com/invertase/melos#readme-badge"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Melos" /></a>
  <a href="https://docs.page"><img src="https://img.shields.io/badge/powered%20by-docs.page-34C4AC.svg?style=flat-square" alt="docs.page" /></a>
</p>


<p align="center">
  <a href="https://docs.page/hyiso/flutterw">Documentation</a> &bull;
  <a href="https://github.com/hyiso/flutterw/blob/main/LICENSE">License</a>
</p>

### About

Flutter Tool is shipped with Flutter SDK every version with some changes. However, upgrading Flutter SDK version is not easy as projects maybe in production mode.

How to be benifited of the Flutter Tool changes without upgrading Flutter SDK is always confusing.
Also, the Flutter Tool does not give chance to do extra work during command running.

To solve these (and other related) problems, flutterw is created.

**Flutterw wraps flutter tool to support scripts and command hooks.**
**Hooks are pre, post and command scripts.**
**`pre` and `post` scripts enable you to do extra work before and after running command**
**and `command` scripts enable you to customize command behavior.**

### What can Flutterw do?

- Dispatch arguments to flutter tool when no command hook configured.
- `pre` scripts are executed before running command.
- `post` scripts are executed after running command.
- `command` scripts are executed to replace original command.
- Command scripts can be packages in [Pub](https://pub.dev/packages?q=flutterw)
  - packages created by flutterw author
    - [flutterw_clean](https://pub.dev/packages/flutterw_clean)
    - [flutterw_hook](https://pub.dev/packages/flutterw_hook)
  - packages created by other developers.
- Add custom to `flutterw`.

## Install

```bash
dart pub global activate flutterw
```

## README Badge

Using Flutterw? Add a README badge to show it off:

[![flutterw](https://img.shields.io/badge/maintained%20with-flutterw-27b6f6.svg?style=flat-square)](https://github.com/hyiso/flutterw)

```markdown
[![flutterw](https://img.shields.io/badge/maintained%20with-flutterw-27b6f6.svg?style=flat-square)](https://github.com/hyiso/flutterw)
```