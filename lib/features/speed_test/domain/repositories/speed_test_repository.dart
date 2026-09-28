import '../entities/speed_test_state.dart';

/// Abstraction over the underlying speed-test engine.
///
/// The rest of the app only ever talks to this interface, never to the
/// concrete measurement package directly. If `flutter_internet_speed_test_pro`
/// is ever replaced by another engine, only [SpeedTestRepositoryImpl] needs
/// to change - no UI or state-management code is affected.
abstract class SpeedTestRepository {
  /// Verifies there is a real, working internet connection before any
  /// test traffic is sent. Returns false if there is none.
  Future<bool> checkConnection();

  /// Resolves and returns a human-readable name for the server that will
  /// be used for the download/upload test.
  Future<String> findBestServer();

  /// Runs the ICMP ping test and returns the average round-trip time in
  /// milliseconds.
  Future<double> startPingTest();

  /// Runs the download test, emitting live Mbps + progress (0-1) pairs as
  /// the transfer proceeds, and completing when the test is done.
  Stream<SpeedTestState> startDownloadTest();

  /// Runs the upload test, emitting live Mbps + progress (0-1) pairs as
  /// the transfer proceeds, and completing when the test is done.
  Stream<SpeedTestState> startUploadTest();

  /// Runs the full ping -> download -> upload sequence end-to-end,
  /// emitting a [SpeedTestState] for every meaningful update. This is the
  /// method the presentation layer subscribes to.
  Stream<SpeedTestState> runFullTest();

  /// Immediately stops any in-flight test and releases its resources.
  Future<void> cancelTest();

  /// Releases sockets/timers held by the repository. Call once when the
  /// owning provider is disposed.
  void dispose();
}
