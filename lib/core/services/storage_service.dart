import 'package:hive_flutter/hive_flutter.dart';

import '../../features/history/data/models/history_item_model.dart';
import '../constants/app_constants.dart';

/// Initialises Hive and opens every box the app needs, once, at startup.
///
/// Kept as a single bootstrap point so `main.dart` stays tiny and every
/// feature can simply call [StorageService.init] before `runApp`.
class StorageService {
  StorageService._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(HistoryItemModelAdapter().typeId)) {
      Hive.registerAdapter(HistoryItemModelAdapter());
    }

    await Hive.openBox<HistoryItemModel>(AppConstants.historyBoxName);
    await Hive.openBox(AppConstants.settingsBoxName);

    _initialized = true;
  }
}
