// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'app/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization for local persistence
  await Hive.initFlutter();
  // Phase 3+: register Hive adapters and open boxes here

  // Dependency injection
  await setupServiceLocator();

  // Lock to portrait for accessibility — landscape layout is Phase 4+ concern
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const VozClaraApp());
}
