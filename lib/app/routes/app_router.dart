import 'package:flutter/material.dart';

import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/network_info/presentation/screens/network_info_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/speed_test/presentation/screens/home_screen.dart';

/// Route names used across the app.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String history = '/history';
  static const String networkInfo = '/network-info';
  static const String settings = '/settings';
}

/// Central route table, kept simple (named routes) since NetSpeed has a
/// small, flat navigation structure with no deep-linking requirements.
class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> routes() {
    return {
      AppRoutes.home: (_) => const HomeScreen(),
      AppRoutes.history: (_) => const HistoryScreen(),
      AppRoutes.networkInfo: (_) => const NetworkInfoScreen(),
      AppRoutes.settings: (_) => const SettingsScreen(),
    };
  }
}
