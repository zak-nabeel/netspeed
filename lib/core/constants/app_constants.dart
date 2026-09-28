/// Global, non-quality-related constants for the app.
class AppConstants {
  AppConstants._();

  /// Hive box names.
  static const String historyBoxName = 'speed_test_history_box';
  static const String settingsBoxName = 'settings_box';

  /// Settings keys stored inside [settingsBoxName].
  static const String settingsThemeKey = 'theme_mode';
  static const String settingsUnitKey = 'speed_unit';
  static const String settingsLocaleKey = 'locale_code';

  /// Maximum number of history entries kept on the device.
  static const int maxHistoryEntries = 200;

  /// Number of most-recent entries shown on the history chart.
  static const int chartEntryCount = 10;

  /// Ping test configuration.
  static const int pingCount = 4;
  static const String pingHost = '8.8.8.8';
  static const Duration pingTimeout = Duration(seconds: 5);

  /// Overall safety timeout for the whole speed test, in case the
  /// underlying engine never reports completion (e.g. dead server).
  static const Duration overallTestTimeout = Duration(seconds: 45);

  /// How often connectivity is allowed to be re-checked automatically.
  static const Duration connectivityCheckTimeout = Duration(seconds: 6);

  /// A small, reliable endpoint used purely to verify that a Wi-Fi /
  /// mobile-data connection actually has real internet access
  /// (a captive portal or dead Wi-Fi can be "connected" with no internet).
  static const String connectivityProbeUrl = 'https://clients3.google.com/generate_204';
}
