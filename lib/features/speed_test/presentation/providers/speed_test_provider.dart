import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../history/data/repositories/history_repository_impl.dart';
import '../../../history/domain/repositories/history_repository.dart';
import '../../data/repositories/speed_test_repository_impl.dart';
import '../../domain/entities/speed_test_result.dart';
import '../../domain/entities/speed_test_state.dart';
import '../../domain/repositories/speed_test_repository.dart';

final speedTestRepositoryProvider = Provider<SpeedTestRepository>((ref) {
  final repo = SpeedTestRepositoryImpl();
  ref.onDispose(repo.dispose);
  return repo;
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl();
});

/// Drives the whole speed-test lifecycle for the UI: starting, cancelling,
/// and persisting a finished result to history.
class SpeedTestNotifier extends Notifier<SpeedTestState> {
  StreamSubscription<SpeedTestState>? _subscription;
  static const _uuid = Uuid();

  SpeedTestRepository get _repository => ref.read(speedTestRepositoryProvider);
  HistoryRepository get _historyRepository => ref.read(historyRepositoryProvider);

  @override
  SpeedTestState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return const SpeedTestState();
  }

  Future<void> startTest() async {
    if (state.isRunning) return;

    await _subscription?.cancel();
    state = const SpeedTestState(phase: SpeedTestPhase.checkingConnection);

    _subscription = _repository.runFullTest().listen(
      (newState) {
        state = newState;
        if (newState.phase == SpeedTestPhase.completed) {
          _persist(newState);
        }
      },
      onError: (_) {
        // Repository already funnels errors into SpeedTestState(phase: error);
        // this is a defensive fallback in case a raw exception escapes.
      },
    );
  }

  Future<void> _persist(SpeedTestState finished) async {
    final result = SpeedTestResult(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      downloadMbps: finished.currentDownloadMbps,
      uploadMbps: finished.currentUploadMbps,
      pingMs: finished.pingMs,
      connectionType: finished.connectionType,
      wifiName: finished.wifiName,
    );
    state = state.copyWith(result: result);
    await _historyRepository.add(result);
    ref.invalidate(historyListProvider);
  }

  Future<void> cancelTest() async {
    await _repository.cancelTest();
    await _subscription?.cancel();
    state = const SpeedTestState(phase: SpeedTestPhase.cancelled);
  }

  void reset() {
    _subscription?.cancel();
    state = const SpeedTestState();
  }
}

final speedTestProvider = NotifierProvider<SpeedTestNotifier, SpeedTestState>(
  SpeedTestNotifier.new,
);

/// Re-exported here (and defined for real in the history feature) to avoid
/// a circular import; the history provider file re-exposes the same
/// provider instance via a shared key.
final historyListProvider = FutureProvider<List<SpeedTestResult>>((ref) async {
  final repo = ref.watch(historyRepositoryProvider);
  return repo.getAll();
});
