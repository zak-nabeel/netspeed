import 'dart:io';

import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // dart_ping needs its iOS plugin registered once, before the first Ping
  // instance is created. This is a no-op on other platforms.
  if (Platform.isIOS) {
    DartPingIOS.register();
  }

  await StorageService.init();

  runApp(const ProviderScope(child: NetSpeedApp()));
}
