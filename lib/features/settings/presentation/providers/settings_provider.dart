import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/speed_converter.dart';

class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.speedUnit = SpeedUnit.mbps,
    this.locale = const Locale('en'),
  });

  final ThemeMode themeMode;
  final SpeedUnit speedUnit;
  final Locale locale;

  SettingsState copyWith({
    ThemeMode? themeMode,
    SpeedUnit? speedUnit,
    Locale? locale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      speedUnit: speedUnit ?? this.speedUnit,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  Box get _box => Hive.box(AppConstants.settingsBoxName);

  @override
  SettingsState build() {
    final themeIndex = _box.get(AppConstants.settingsThemeKey, defaultValue: 0) as int;
    final unitIndex = _box.get(AppConstants.settingsUnitKey, defaultValue: 0) as int;
    final localeCode = _box.get(AppConstants.settingsLocaleKey, defaultValue: 'en') as String;

    return SettingsState(
      themeMode: ThemeMode.values[themeIndex],
      speedUnit: SpeedUnit.values[unitIndex],
      locale: Locale(localeCode),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _box.put(AppConstants.settingsThemeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setSpeedUnit(SpeedUnit unit) async {
    await _box.put(AppConstants.settingsUnitKey, unit.index);
    state = state.copyWith(speedUnit: unit);
  }

  Future<void> setLocale(Locale locale) async {
    await _box.put(AppConstants.settingsLocaleKey, locale.languageCode);
    state = state.copyWith(locale: locale);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
