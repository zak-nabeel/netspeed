import 'package:equatable/equatable.dart';

import '../../../../core/services/connectivity_service.dart';

/// An immutable, fully-finished speed test measurement.
///
/// This is the single source of truth shared between the speed-test
/// feature (which produces it) and the history feature (which persists
/// and displays it), avoiding duplicate models for the same data.
class SpeedTestResult extends Equatable {
  const SpeedTestResult({
    required this.id,
    required this.timestamp,
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    required this.connectionType,
    this.wifiName,
  });

  final String id;
  final DateTime timestamp;
  final double downloadMbps;
  final double uploadMbps;
  final double pingMs;
  final NetworkType connectionType;
  final String? wifiName;

  @override
  List<Object?> get props => [
        id,
        timestamp,
        downloadMbps,
        uploadMbps,
        pingMs,
        connectionType,
        wifiName,
      ];
}
