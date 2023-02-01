> A package for `build aar` command hook script of [flutterw](https://pub.dev/packages/flutterw).

# About
Currently `flutter build aar` read version from `--build-number`, and set this version to each Flutter Plugin AAR and Flutter Module AAR.

But consider these situations:

1. Multi Flutter Modules use same Flutter Plugin and same version, when build with different `--build-number`, will generate different version AAR of this Flutter Plugin.
  
    - Here same version AAR of this Flutter Plugin is expected.
2. Multi Flutter Modules use same Flutter Plugin but different version, when build with same `--build-number`, will generate same version AAR of this Flutter Plugin.
    
    - Here different version AAR of thi Flutter Plugin is expected.

To meet these situations, `build aar` should read version in pubspec.yaml for each Flutter Plugin.

`flutterw_build_aar` is created to satisfy these expectations.

Note: Flutter Module AAR version will not use `--build-number`, but the `version` in pubspec.yaml of the Flutter Module Project.

# Basic Usage

Add `flutterw_build_aar` to Flutter module's `dev_dependencies` in pubsepc.yaml
```yaml
dev_dependencies:
  flutterw_build_aar: latest
```

Config `build:aar` scripts for `flutterw` in pubspec.yaml
```yaml
scripts:
  build:aar: flutter pub run flutterw_build_aar <args>
```

After pub get, running `flutterw build aar` will use `flutterw_build_aar` to generate plugin AARs with version in there pubspec.yaml.

# Advanced

If you want to publish AARs to internal maven repository, just add `--android-project-arg=maven-url=<maven-url>`, `--android-project-arg=maven-username=<maven-username>` and `--android-project-arg=maven-password=<maven-password>` to `flutterw build aar`.

This will publish each Flutter Plugin AAR and Flutter Module AAR to the given maven repository <maven-url>:

- use authentication with <maven-username> and <maven-password>.
- If the version of Flutter Plugin AAR already exists, skip publishing.
- If the version of Flutter Module AAR already exists, throw a `RuntimeException`.

# Example

> See the [example](https://github.com/hyiso/flutterw)
