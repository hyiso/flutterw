# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2023-01-14

### Changes

---

Packages with breaking changes:

 - [`flutterw` - `v0.7.0`](#flutterw---v070)
 - [`flutterw_clean` - `v0.2.0`](#flutterw_clean---v020)

Packages with other changes:

 - There are no other changes in this release.

---

#### `flutterw` - `v0.7.0`

 - **FIX**: flutterw_test. ([9b544c76](https://github.com/hyiso/flutterw/commit/9b544c7649e2232acc5cc4ad6ade2d845ceacec1))
 - **FIX**: Forget to update kFlutterwVersion. ([e60f9d23](https://github.com/hyiso/flutterw/commit/e60f9d23915a9a20b8c16356aa8c2f5b7c01eff5))
 - **DOCS**: Migrate to docsify ([#14](https://github.com/hyiso/flutterw/issues/14)). ([0bed7ce4](https://github.com/hyiso/flutterw/commit/0bed7ce4f5de1111bed75e27d71862cdb4c17553))
 - **DOCS**: Add adding-custom-command doc. ([3534ee10](https://github.com/hyiso/flutterw/commit/3534ee1050d3a056a339f7389956a0f2b890e7e1))
 - **DOCS**: change github issue template. ([eb19b735](https://github.com/hyiso/flutterw/commit/eb19b7355c6078087071c61148cc0adc3a070bd4))
 - **BREAKING** **FEAT**: Add scripts support and merge hooks to scripts ([#13](https://github.com/hyiso/flutterw/issues/13)). ([d85bf309](https://github.com/hyiso/flutterw/commit/d85bf309a9b1acb859d182b5d99a0d7222ff44cb))
 - **BREAKING** **FEAT**: Migrate config file form flutterw.yaml to pubspec.yaml. ([2ab61c78](https://github.com/hyiso/flutterw/commit/2ab61c7887fc015fc8ccb20d29756f7e7dd133c1))

#### `flutterw_clean` - `v0.2.0`

 - **BREAKING** **FEAT**: Add scripts support and merge hooks to scripts ([#13](https://github.com/hyiso/flutterw/issues/13)). ([d85bf309](https://github.com/hyiso/flutterw/commit/d85bf309a9b1acb859d182b5d99a0d7222ff44cb))
 - **BREAKING** **FEAT**: Migrate config file form flutterw.yaml to pubspec.yaml. ([2ab61c78](https://github.com/hyiso/flutterw/commit/2ab61c7887fc015fc8ccb20d29756f7e7dd133c1))


## 2023-01-08

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`flutterw` - `v0.6.1`](#flutterw---v061)

---

#### `flutterw` - `v0.6.1`

 - Update `cli_hook` and docs


## 2023-01-08

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`cli_hook` - `v0.2.0`](#cli_hook---v020)

---

#### `cli_hook` - `v0.2.0`

 - Make Hook more extensive


## 2023-01-08

### Changes

---

New packages:

 - [`cli_hook` - `v0.1.2`](#cli_hook---v012)

Packages with breaking changes:

 - [`cli_wrapper` - `v0.5.0`](#cli_wrapper---v050)

 - [`flutterw` - `v0.6.0`](#flutterw---v060)

Packages with other changes:

 - [`flutterw_hook` - `v0.2.0`](#flutterw_hook---v020)

---

#### `flutterw_hook` - `v0.2.0`

 - Upgrade flutterw version


#### `flutterw` - `v0.6.0`

 - Make flutterw depende on cli_hook and cli_wrapper
 - Breaking Change
   - hook name separator changed from underline(`_`) to colon(`:`).


#### `cli_wrapper` - `v0.5.0`

 - Move hook support to package `cli_hook`.

#### `cli_hook` - `v0.1.2`

 - Fix analyze issue
 - Change min sdk version to `2.12.0`.
 - Support hooks for CommandRunner.

