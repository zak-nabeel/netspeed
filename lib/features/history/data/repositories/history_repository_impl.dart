import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../speed_test/domain/entities/speed_test_result.dart';
import '../../domain/repositories/history_repository.dart';
import '../models/history_item_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({Box<HistoryItemModel>? box}) : _box = box;

  final Box<HistoryItemModel>? _box;

  Box<HistoryItemModel> get _resolvedBox =>
      _box ?? Hive.box<HistoryItemModel>(AppConstants.historyBoxName);

  @override
  Future<List<SpeedTestResult>> getAll() async {
    final items = _resolvedBox.values.toList()
      ..sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> add(SpeedTestResult result) async {
    final box = _resolvedBox;
    await box.put(result.id, HistoryItemModel.fromEntity(result));

    if (box.length > AppConstants.maxHistoryEntries) {
      final sortedKeys = box.values.toList()
        ..sort((a, b) => a.timestampMillis.compareTo(b.timestampMillis));
      final overflow = box.length - AppConstants.maxHistoryEntries;
      for (var i = 0; i < overflow; i++) {
        await sortedKeys[i].delete();
      }
    }
  }

  @override
  Future<void> clear() async {
    await _resolvedBox.clear();
  }
}
