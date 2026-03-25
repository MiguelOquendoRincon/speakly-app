// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:voz_clara/features/phrases/data/repositories/phrases_repository_impl.dart';
import 'app/app.dart';
import 'app/service_locator.dart';

/// Application entry point.
///
/// Initializes Hive persistence, registers dependencies, locks the device
/// to portrait orientation, and launches [VozClaraApp].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization for local persistence
  await Hive.initFlutter();
  await PhrasesRepositoryImpl.openBoxes();

  // Dependency injection
  await setupServiceLocator();

  // Lock to portrait for accessibility — landscape layout is Phase 4+ concern
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const VozClaraApp());
}
