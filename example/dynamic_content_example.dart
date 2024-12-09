import 'dart:io';

import 'package:dynamic_content/dynamic_content.dart';

void main() async {
  final settingsContent = DynamicContent(
      variants: [
        'https://some-remote-endpoint.org/config-${Platform.operatingSystem}.zip',
        'https://some-remote-endpoint.org/config.zip'
      ],
      localPath: 'config.json',
      bundlePath: 'assets/config-${Platform.operatingSystem}.json');

// fetch current content (from assets or cached)
  final Map<String, dynamic> settingsMap = await settingsContent.fetch();
  print(settingsMap);

// update ads settings from remote
  await settingsContent.update();
}
