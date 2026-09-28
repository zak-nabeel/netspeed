import 'package:flutter_test/flutter_test.dart';
import 'package:netspeed/core/errors/app_exceptions.dart';
import 'package:netspeed/core/services/connectivity_service.dart';
import 'package:netspeed/features/speed_test/domain/entities/speed_test_state.dart';

void main() {
  group('SpeedTestState.isRunning', () {
    test('idle is not running', () {
      const state = SpeedTestState(phase: SpeedTestPhase.idle);
      expect(state.isRunning, isFalse);
    });

    test('checkingConnection, findingServer, testingPing/Download/Upload are running', () {
      for (final phase in [
        SpeedTestPhase.checkingConnection,
        SpeedTestPhase.findingServer,
        SpeedTestPhase.testingPing,
        SpeedTestPhase.testingDownload,
        SpeedTestPhase.testingUpload,
      ]) {
        expect(SpeedTestState(phase: phase).isRunning, isTrue, reason: '$phase should be running');
      }
    });

    test('completed, cancelled, error are not running', () {
      for (final phase in [
        SpeedTestPhase.completed,
        SpeedTestPhase.cancelled,
        SpeedTestPhase.error,
      ]) {
        expect(SpeedTestState(phase: phase).isRunning, isFalse, reason: '$phase should not be running');
      }
    });
  });

  group('SpeedTestState error state', () {
    test('error phase carries the originating exception', () {
      const state = SpeedTestState(
        phase: SpeedTestPhase.error,
        error: NoInternetException(),
      );
      expect(state.error, isA<NoInternetException>());
      expect(state.error!.messageKey, 'noInternetMessage');
    });

    test('copyWith preserves fields not overridden', () {
      const original = SpeedTestState(
        phase: SpeedTestPhase.testingDownload,
        progress: 0.5,
        currentDownloadMbps: 42,
        connectionType: NetworkType.wifi,
      );
      final updated = original.copyWith(progress: 0.75);

      expect(updated.phase, SpeedTestPhase.testingDownload);
      expect(updated.progress, 0.75);
      expect(updated.currentDownloadMbps, 42);
      expect(updated.connectionType, NetworkType.wifi);
    });
  });
}
