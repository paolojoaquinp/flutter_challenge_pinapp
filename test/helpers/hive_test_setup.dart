import 'dart:io';

import 'package:hive/hive.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';

Directory? _hiveTempDir;

Future<void> setUpHive() async {
  _hiveTempDir = Directory.systemTemp.createTempSync('hive_test_');
  Hive.init(_hiveTempDir!.path);
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MovieModelAdapter());
  }
}

Future<void> tearDownHive() async {
  await Hive.close();
  if (_hiveTempDir != null && _hiveTempDir!.existsSync()) {
    _hiveTempDir!.deleteSync(recursive: true);
  }
  _hiveTempDir = null;
}
