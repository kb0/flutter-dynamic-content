## Usage

```dart
import 'package:gpx/gpx.dart';

final variants = [
  "https://remote.org/icons-${Platform.operatingSystem}.zip",
  "https://remote.org/icons.zip",
];

final content = DynamicContent(
    variants: variants, localPath: "apps.json", bundlePath: "assets/apps/apps-${Platform.operatingSystem}.json");

var recentJson = await content.fetchRecentContent();
```