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

**Flutterw  wraps the flutter tool to support command hooks system.**
**`pre` and `post` hooks enable you to do extra work before and after command running**
**and `command` hooks enable you to customize command behavior.**

### What can Flutterw do?

- Dispatch arguments to flutter tool when no command hook configured.
- Command hooks system support packages in [Pub](https://pub.dev)
  - packages created by flutterw author.(eg: [flutterw_clean](https://pub.dev/packages/flutterw_clean))
  - packages created by other developers.
- Global command hooks can be shared cross projects.
- Project hooks simplify project workflow.
  - Hook scripts can do whatever you want before and after command running.

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