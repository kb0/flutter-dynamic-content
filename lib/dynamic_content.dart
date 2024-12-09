library dynamic_content;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'logging.dart';

class DynamicContent {
  final List<String> variants;

  final String localPath;
  final String bundlePath;

  final Duration ttl;

  static Directory? _temporaryDirectory;

  DynamicContent(
      {required this.localPath,
      required this.bundlePath,
      required this.variants,
      this.ttl = const Duration(hours: 8)});

  Future<Directory> storagePath() async =>
      _temporaryDirectory ?? await getApplicationSupportDirectory();

  Future<File> _localFile(String name) async =>
      File('${(await storagePath()).path}/$name');

  Future<dynamic> fetch() async {
    final json = await fetchRecentContent();
    if (json != null) {
      try {
        return jsonDecode(json);
      } on Exception catch (e) {
        logger.error('error during parsing remote json ($json) - $e');
        unawaited(deleteRecentContent());
      }
    }

    return jsonDecode(await fetchAssetsContent());
  }

  Future<bool> update() async {
    final ttlFile = await _localFile('$localPath.lastModified');
    if (ttlFile.existsSync() &&
        ttlFile
                .lastModifiedSync()
                .difference(DateTime.now())
                .inSeconds <
            ttl.inSeconds) {
      logger.info(
          'skip update from remote, updated at ${ttlFile.lastModifiedSync()}');
      return false;
    }

    // refresh modification datetime
    await ttlFile.writeAsString('${DateTime.now()}');

    final targetFile = await _localFile(localPath);

    for (final variantUrl in variants) {
      if (variantUrl.endsWith('.zip')) {
        if (await _download(variantUrl, File('${targetFile.path}.zip'))) {
          _extract(File('${targetFile.path}.zip'), targetFile.parent);
          if (targetFile.existsSync()) {
            return true;
          }
        }
      } else {
        if (await _download(variantUrl, targetFile)) {
          return true;
        }
      }
    }

    return false;
  }

  Future<String?> fetchRecentContent() async {
    final recentContent = await _localFile(localPath);

    logger.info('verify cached content for - ${recentContent.path}');
    if (recentContent.existsSync()) {
      logger.info('get cached content for - ${recentContent.path}');
      return recentContent.readAsString();
    }

    return null;
  }

  Future<void> deleteRecentContent() async {
    final recentContent = await _localFile(localPath);

    if (recentContent.existsSync()) {
      recentContent.deleteSync();
    }
  }

  Future<String> fetchAssetsContent() async {
    logger.info('get content from bundle - $bundlePath');
    return rootBundle.loadString(bundlePath);
  }

  Future<bool> _download(final String url, final File file) async {
    logger.info('fetch remote resource from $url');
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      logger.info('successful fetch remote resource from $url');
      await file.writeAsString(response.body);

      return true;
    } else {
      logger.info(
          'cannot fetch remote from $url with status ${response.statusCode}');
    }

    return false;
  }

  void _extract(File archiveFile, Directory targetDir) {
    final archive = ZipDecoder().decodeBytes(archiveFile.readAsBytesSync());
    for (final file in archive) {
      logger.info('extract ${file.name} into ${targetDir.path}');
      final filename = file.name;
      if (file.isFile) {
        File(targetDir.path + Platform.pathSeparator + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      } else {
        Directory(targetDir.path + Platform.pathSeparator + filename)
            .create(recursive: true);
      }
    }
  }
}
