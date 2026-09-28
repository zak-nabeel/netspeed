import '../../../speed_test/domain/entities/speed_test_result.dart';

/// Abstraction over local persistence of past speed test results.
abstract class HistoryRepository {
  /// All saved results, most recent first.
  Future<List<SpeedTestResult>> getAll();

  /// Persists a new completed result, trimming old entries beyond the
  /// configured maximum so storage does not grow unbounded.
  Future<void> add(SpeedTestResult result);

  /// Deletes every saved result.
  Future<void> clear();
}
