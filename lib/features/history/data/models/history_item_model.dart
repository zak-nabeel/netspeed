import 'package:hive/hive.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../speed_test/domain/entities/speed_test_result.dart';

part 'history_item_model.g.dart';

/// Hive-persisted version of [SpeedTestResult].
///
/// Kept as a thin, separate storage model (rather than annotating the
/// domain entity directly) so the domain layer never depends on Hive.
@HiveType(typeId: 0)
class HistoryItemModel extends HiveObject {
  HistoryItemModel({
    required this.id,
    required this.timestampMillis,
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    required this.connectionTypeIndex,
    this.wifiName,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int timestampMillis;

  @HiveField(2)
  final double downloadMbps;

  @HiveField(3)
  final double uploadMbps;

  @HiveField(4)
  final double pingMs;

  @HiveField(5)
  final int connectionTypeIndex;

  @HiveField(6)
  final String? wifiName;

  factory HistoryItemModel.fromEntity(SpeedTestResult result) {
    return HistoryItemModel(
      id: result.id,
      timestampMillis: result.timestamp.millisecondsSinceEpoch,
      downloadMbps: result.downloadMbps,
      uploadMbps: result.uploadMbps,
      pingMs: result.pingMs,
      connectionTypeIndex: result.connectionType.index,
      wifiName: result.wifiName,
    );
  }

  SpeedTestResult toEntity() {
    return SpeedTestResult(
      id: id,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      downloadMbps: downloadMbps,
      uploadMbps: uploadMbps,
      pingMs: pingMs,
      connectionType: NetworkType.values[connectionTypeIndex],
      wifiName: wifiName,
    );
  }
}
