dynamic_content
======

[![Pub Package](https://img.shields.io/pub/v/dynamic_content.svg)](https://pub.dartlang.org/packages/dynamic_content)
[![Build Status](https://travis-ci.org/kb0/flutter-dynamic-content.svg?branch=master)](https://travis-ci.org/kb0/flutter-dynamic-content)
[![Coverage Status](https://coveralls.io/repos/github/kb0/flutter-dynamic-content/badge.svg?branch=master)](https://coveralls.io/github/kb0/flutter-dynamic-content?branch=master)
[![GitHub Issues](https://img.shields.io/github/issues/kb0/flutter-dynamic-content.svg?branch=master)](https://github.com/kb0/flutter-dynamic-content/issues)
[![GitHub Forks](https://img.shields.io/github/forks/kb0/flutter-dynamic-content.svg?branch=master)](https://github.com/kb0/flutter-dynamic-content/network)
[![GitHub Stars](https://img.shields.io/github/stars/kb0/flutter-dynamic-content.svg?branch=master)](https://github.com/kb0/flutter-dynamic-content/stargazers)
[![GitHub License](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://raw.githubusercontent.com/kb0/flutter-dynamic-content/master/LICENSE)

DynamicContent is a text file (json) that provided as application assets, and might be updated from remote site (and check updates for a given ttl).

## Getting Started

In your dart/flutter project add the dependency:

```
 dependencies:
   ...
   dynamic_content: ^1.0.0
```

Get cibtebt

```dart
import 'package:dynamic_content/dynamic_content.dart';

final settingsContent = DynamicContent(
    variants: [
      'https://some-remote-endpoint.org/config-${Platform.operatingSystem}.zip',
      'https://some-remote-endpoint.org/config.zip'],
    localPath: 'config.json',
    bundlePath: 'assets/config-${Platform.operatingSystem}.json');

// fetch current content (from assets or cached)
final Map<String, dynamic> adsSettings = await settingsContent.fetch();

// update ads settings from remote
await settingsContent.update();
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/kb0/flutter-dynamic-content/issues

### License

The Apache 2.0 License, see [LICENSE](https://github.com/kb0/flutter-dynamic-content/raw/master/LICENSE).
