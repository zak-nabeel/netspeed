import 'package:equatable/equatable.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import 'speed_test_result.dart';

/// The discrete phases a speed test can be in.
enum SpeedTestPhase {
  idle,
  checkingConnection,
  findingServer,
  testingPing,
  testingDownload,
  testingUpload,
  completed,
  cancelled,
  error,
}

/// A single, immutable snapshot of an in-progress or finished speed test.
///
/// The presentation layer only ever needs to read this one object to
/// render any screen (home / testing / results), which keeps the UI
/// layer simple and free of its own duplicate state.
class SpeedTestState extends Equatable {
  const SpeedTestState({
    this.phase = SpeedTestPhase.idle,
    this.progress = 0,
    this.currentDownloadMbps = 0,
    this.currentUploadMbps = 0,
    this.pingMs = 0,
    this.serverName,
    this.connectionType = NetworkType.unknown,
    this.wifiName,
    this.result,
    this.error,
  });

  final SpeedTestPhase phase;

  /// 0.0 - 1.0 progress of the *current* phase (ping/download/upload).
  final double progress;

  final double currentDownloadMbps;
  final double currentUploadMbps;
  final double pingMs;
  final String? serverName;
  final NetworkType connectionType;
  final String? wifiName;

  /// Populated only once [phase] is [SpeedTestPhase.completed].
  final SpeedTestResult? result;

  /// Populated only when [phase] is [SpeedTestPhase.error].
  final AppException? error;

  bool get isRunning => phase != SpeedTestPhase.idle &&
      phase != SpeedTestPhase.completed &&
      phase != SpeedTestPhase.cancelled &&
      phase != SpeedTestPhase.error;

  SpeedTestState copyWith({
    SpeedTestPhase? phase,
    double? progress,
    double? currentDownloadMbps,
    double? currentUploadMbps,
    double? pingMs,
    String? serverName,
    NetworkType? connectionType,
    String? wifiName,
    SpeedTestResult? result,
    AppException? error,
  }) {
    return SpeedTestState(
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      currentDownloadMbps: currentDownloadMbps ?? this.currentDownloadMbps,
      currentUploadMbps: currentUploadMbps ?? this.currentUploadMbps,
      pingMs: pingMs ?? this.pingMs,
      serverName: serverName ?? this.serverName,
      connectionType: connectionType ?? this.connectionType,
      wifiName: wifiName ?? this.wifiName,
      result: result ?? this.result,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        progress,
        currentDownloadMbps,
        currentUploadMbps,
        pingMs,
        serverName,
        connectionType,
        wifiName,
        result,
        error,
      ];
}
