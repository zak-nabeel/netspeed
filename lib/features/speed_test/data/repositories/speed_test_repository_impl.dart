import 'dart:async';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_internet_speed_test_pro/flutter_internet_speed_test_pro.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../domain/entities/speed_test_state.dart';
import '../../domain/repositories/speed_test_repository.dart';

/// Real implementation of [SpeedTestRepository].
///
/// - Ping is measured with real ICMP echo requests via `dart_ping`.
/// - Download/Upload are measured with real network transfers via
///   `flutter_internet_speed_test_pro`.
///
/// No random numbers or fabricated values are produced.
class SpeedTestRepositoryImpl implements SpeedTestRepository {
  SpeedTestRepositoryImpl({
    ConnectivityService? connectivityService,
    FlutterInternetSpeedTest? speedTestEngine,
  })  : _connectivityService = connectivityService ?? ConnectivityService(),
        _engine = speedTestEngine ?? FlutterInternetSpeedTest();

  final ConnectivityService _connectivityService;
  final FlutterInternetSpeedTest _engine;

  Ping? _activePing;
  bool _cancelled = false;
  StreamController<SpeedTestState>? _controller;

  // ===============================================================
  // CONNECTION
  // ===============================================================

  @override
  Future<bool> checkConnection() {
    return _connectivityService.hasRealInternetAccess();
  }

  // ===============================================================
  // SERVER
  // ===============================================================

  @override
  Future<String> findBestServer() async {
    // flutter_internet_speed_test_pro uses Fast.com / Netflix
    // Open Connect by default when useFastApi is true.
    //
    // There is no separate "find server" operation exposed by
    // the package API.
    return 'Fast.com (Netflix Open Connect)';
  }

  // ===============================================================
  // PING
  // ===============================================================

  @override
  Future<double> startPingTest() async {
    if (_cancelled) {
      throw const TestCancelledException();
    }

    final ping = Ping(
      AppConstants.pingHost,
      count: AppConstants.pingCount,
    );

    _activePing = ping;

    final rtts = <double>[];
    final completer = Completer<double>();

    final subscription = ping.stream.listen(
      (event) {
        final response = event.response;

        if (response?.time != null) {
          rtts.add(
            response!.time!.inMicroseconds / 1000.0,
          );
        }

        if (event.summary != null && !completer.isCompleted) {
          if (rtts.isEmpty) {
            completer.completeError(
              const ServerUnavailableException(),
            );
          } else {
            final average = rtts.reduce((a, b) => a + b) / rtts.length;

            completer.complete(average);
          }
        }
      },
      onError: (_) {
        if (!completer.isCompleted) {
          completer.completeError(
            const ServerUnavailableException(),
          );
        }
      },
    );

    try {
      return await completer.future.timeout(
        AppConstants.pingTimeout * (AppConstants.pingCount + 2),
        onTimeout: () {
          if (rtts.isEmpty) {
            throw const TestTimeoutException();
          }

          return rtts.reduce((a, b) => a + b) / rtts.length;
        },
      );
    } finally {
      await subscription.cancel();
      _activePing = null;
    }
  }

  // ===============================================================
  // DOWNLOAD TEST
  // ===============================================================

  @override
  Stream<SpeedTestState> startDownloadTest() {
    final controller = StreamController<SpeedTestState>();

    _engine.startTesting(
      onProgress: (percent, data) {
        if (controller.isClosed) return;

        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.testingDownload,
            progress: (percent / 100.0).clamp(0.0, 1.0),
            currentDownloadMbps: _toMbps(data),
          ),
        );
      },

      onDownloadComplete: (data) {
        if (controller.isClosed) return;

        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.testingDownload,
            progress: 1.0,
            currentDownloadMbps: _toMbps(data),
          ),
        );
      },

      onUploadComplete: (data) {
        // The package always performs upload as part of the
        // complete speed-test cycle.
        //
        // Nothing is emitted here because this method is intended
        // to expose only the download phase.
      },

      onError: (message, error) {
        if (controller.isClosed) return;

        controller.addError(
          ServerUnavailableException(),
        );

        controller.close();
      },

      onCancel: () {
        if (controller.isClosed) return;

        controller.addError(
          const TestCancelledException(),
        );

        controller.close();
      },

      // IMPORTANT:
      // ResultCallback is:
      //
      // void Function(TestResult download, TestResult upload)
      //
      onCompleted: (download, upload) {
        if (controller.isClosed) return;

        // Use the final download result.
        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.testingDownload,
            progress: 1.0,
            currentDownloadMbps: _toMbps(download),
          ),
        );

        controller.close();
      },
    );

    return controller.stream;
  }

  // ===============================================================
  // UPLOAD TEST
  // ===============================================================

  @override
  Stream<SpeedTestState> startUploadTest() {
    final controller = StreamController<SpeedTestState>();

    _engine.startTesting(
      onProgress: (percent, data) {
        if (controller.isClosed) return;

        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.testingUpload,
            progress: (percent / 100.0).clamp(0.0, 1.0),
            currentUploadMbps: _toMbps(data),
          ),
        );
      },
      onDownloadComplete: (data) {
        // Download is performed by the underlying engine before
        // upload. We intentionally don't expose it here.
      },
      onUploadComplete: (data) {
        if (controller.isClosed) return;

        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.testingUpload,
            progress: 1.0,
            currentUploadMbps: _toMbps(data),
          ),
        );
      },
      onError: (message, error) {
        if (controller.isClosed) return;

        controller.addError(
          ServerUnavailableException(),
        );

        controller.close();
      },
      onCancel: () {
        if (controller.isClosed) return;

        controller.addError(
          const TestCancelledException(),
        );

        controller.close();
      },
      onCompleted: (download, upload) {
        if (controller.isClosed) return;

        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.testingUpload,
            progress: 1.0,
            currentUploadMbps: _toMbps(upload),
          ),
        );

        controller.close();
      },
    );

    return controller.stream;
  }

  // ===============================================================
  // FULL TEST
  // ===============================================================

  @override
  Stream<SpeedTestState> runFullTest() {
    _cancelled = false;

    final controller = StreamController<SpeedTestState>();

    _controller = controller;

    unawaited(
      _run(controller),
    );

    controller.onCancel = () {
      cancelTest();
    };

    return controller.stream;
  }

  // ===============================================================
  // RUN FULL TEST
  // ===============================================================

  Future<void> _run(
    StreamController<SpeedTestState> controller,
  ) async {
    try {
      // -----------------------------------------------------------
      // CHECK INTERNET
      // -----------------------------------------------------------

      controller.add(
        const SpeedTestState(
          phase: SpeedTestPhase.checkingConnection,
        ),
      );

      final hasInternet = await checkConnection();

      if (_cancelled) {
        return _emitCancelled(controller);
      }

      if (!hasInternet) {
        if (!controller.isClosed) {
          controller.add(
            const SpeedTestState(
              phase: SpeedTestPhase.error,
              error: NoInternetException(),
            ),
          );

          await controller.close();
        }

        return;
      }

      // -----------------------------------------------------------
      // CONNECTION TYPE
      // -----------------------------------------------------------

      final connectionType = await _connectivityService.currentType();

      // -----------------------------------------------------------
      // FIND SERVER
      // -----------------------------------------------------------

      controller.add(
        SpeedTestState(
          phase: SpeedTestPhase.findingServer,
          connectionType: connectionType,
        ),
      );

      final serverName = await findBestServer();

      if (_cancelled) {
        return _emitCancelled(controller);
      }

      // -----------------------------------------------------------
      // PING
      // -----------------------------------------------------------

      controller.add(
        SpeedTestState(
          phase: SpeedTestPhase.testingPing,
          serverName: serverName,
          connectionType: connectionType,
        ),
      );

      final pingMs = await startPingTest();

      if (_cancelled) {
        return _emitCancelled(controller);
      }

      controller.add(
        SpeedTestState(
          phase: SpeedTestPhase.testingPing,
          progress: 1.0,
          pingMs: pingMs,
          serverName: serverName,
          connectionType: connectionType,
        ),
      );

      // -----------------------------------------------------------
      // SPEED TEST
      // -----------------------------------------------------------

      final speedTestCompleter = Completer<_SpeedTestResult>();

      bool downloadCompleted = false;
      double currentDownloadMbps = 0.0;

      _engine.startTesting(
        // ---------------------------------------------------------
        // PROGRESS
        // ---------------------------------------------------------

        onProgress: (percent, data) {
          if (_cancelled || controller.isClosed) {
            return;
          }

          final progress = (percent / 100.0).clamp(0.0, 1.0);

          final currentMbps = _toMbps(data);

          if (!downloadCompleted) {
            // -----------------------------------------------------
            // DOWNLOAD
            // -----------------------------------------------------

            currentDownloadMbps = currentMbps;

            controller.add(
              SpeedTestState(
                phase: SpeedTestPhase.testingDownload,
                progress: progress,
                currentDownloadMbps: currentDownloadMbps,
                pingMs: pingMs,
                serverName: serverName,
                connectionType: connectionType,
              ),
            );
          } else {
            // -----------------------------------------------------
            // UPLOAD
            // -----------------------------------------------------

            controller.add(
              SpeedTestState(
                phase: SpeedTestPhase.testingUpload,
                progress: progress,
                currentDownloadMbps: currentDownloadMbps,
                currentUploadMbps: currentMbps,
                pingMs: pingMs,
                serverName: serverName,
                connectionType: connectionType,
              ),
            );
          }
        },

        // ---------------------------------------------------------
        // DOWNLOAD COMPLETE
        // ---------------------------------------------------------

        onDownloadComplete: (data) {
          downloadCompleted = true;

          currentDownloadMbps = _toMbps(data);

          if (_cancelled || controller.isClosed) {
            return;
          }

          controller.add(
            SpeedTestState(
              phase: SpeedTestPhase.testingDownload,
              progress: 1.0,
              currentDownloadMbps: currentDownloadMbps,
              pingMs: pingMs,
              serverName: serverName,
              connectionType: connectionType,
            ),
          );
        },

        // ---------------------------------------------------------
        // UPLOAD COMPLETE
        // ---------------------------------------------------------

        onUploadComplete: (data) {
          if (_cancelled || controller.isClosed) {
            return;
          }

          final uploadMbps = _toMbps(data);

          controller.add(
            SpeedTestState(
              phase: SpeedTestPhase.testingUpload,
              progress: 1.0,
              currentDownloadMbps: currentDownloadMbps,
              currentUploadMbps: uploadMbps,
              pingMs: pingMs,
              serverName: serverName,
              connectionType: connectionType,
            ),
          );
        },

        // ---------------------------------------------------------
        // ERROR
        // ---------------------------------------------------------

        onError: (message, error) {
          if (!speedTestCompleter.isCompleted) {
            speedTestCompleter.completeError(
              ServerUnavailableException(),
            );
          }
        },

        // ---------------------------------------------------------
        // CANCEL
        // ---------------------------------------------------------

        onCancel: () {
          if (!speedTestCompleter.isCompleted) {
            speedTestCompleter.completeError(
              const TestCancelledException(),
            );
          }
        },

        // ---------------------------------------------------------
        // COMPLETED
        // ---------------------------------------------------------

        onCompleted: (download, upload) {
          if (speedTestCompleter.isCompleted) {
            return;
          }

          final downloadMbps = _toMbps(download);

          final uploadMbps = _toMbps(upload);

          speedTestCompleter.complete(
            _SpeedTestResult(
              downloadMbps: downloadMbps,
              uploadMbps: uploadMbps,
            ),
          );
        },
      );

      // -----------------------------------------------------------
      // WAIT FOR COMPLETE RESULT
      // -----------------------------------------------------------

      final result = await speedTestCompleter.future.timeout(
        AppConstants.overallTestTimeout,
        onTimeout: () {
          throw const TestTimeoutException();
        },
      );

      if (_cancelled) {
        return _emitCancelled(controller);
      }

      // -----------------------------------------------------------
      // FINAL STATE
      // -----------------------------------------------------------

      if (!controller.isClosed) {
        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.completed,
            progress: 1.0,
            currentDownloadMbps: result.downloadMbps,
            currentUploadMbps: result.uploadMbps,
            pingMs: pingMs,
            serverName: serverName,
            connectionType: connectionType,
          ),
        );

        await controller.close();
      }
    }

    // =============================================================
    // APP EXCEPTION
    // =============================================================

    on AppException catch (e) {
      if (_cancelled) {
        return _emitCancelled(controller);
      }

      if (!controller.isClosed) {
        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.error,
            error: e,
          ),
        );

        await controller.close();
      }
    }

    // =============================================================
    // UNKNOWN EXCEPTION
    // =============================================================

    catch (e) {
      if (_cancelled) {
        return _emitCancelled(controller);
      }

      if (!controller.isClosed) {
        controller.add(
          SpeedTestState(
            phase: SpeedTestPhase.error,
            error: UnknownTestException(
              e.toString(),
            ),
          ),
        );

        await controller.close();
      }
    }
  }

  // ===============================================================
  // CANCELLED
  // ===============================================================

  void _emitCancelled(
    StreamController<SpeedTestState> controller,
  ) {
    if (controller.isClosed) {
      return;
    }

    controller.add(
      const SpeedTestState(
        phase: SpeedTestPhase.cancelled,
      ),
    );

    controller.close();
  }

  // ===============================================================
  // CONVERT TEST RESULT TO Mbps
  // ===============================================================

  double _toMbps(TestResult data) {
    switch (data.unit) {
      case SpeedUnit.kbps:
        return data.transferRate / 1000.0;

      case SpeedUnit.mbps:
        return data.transferRate;
    }
  }

  // ===============================================================
  // CANCEL TEST
  // ===============================================================

  @override
  Future<void> cancelTest() async {
    _cancelled = true;

    try {
      await _engine.cancelTest();
    } catch (_) {
      // There may be no active speed test.
    }

    try {
      await _activePing?.stop();
    } catch (_) {
      // Ping may already be stopped.
    }

    _activePing = null;
  }

  // ===============================================================
  // DISPOSE
  // ===============================================================

  @override
  void dispose() {
    _cancelled = true;

    try {
      _engine.cancelTest();
    } catch (_) {
      // Ignore cancellation errors.
    }

    try {
      _activePing?.stop();
    } catch (_) {
      // Ignore ping stop errors.
    }

    if (_controller != null && !_controller!.isClosed) {
      _controller!.close();
    }

    _activePing = null;
    _controller = null;
  }
}

// =================================================================
// INTERNAL SPEED TEST RESULT
// =================================================================

class _SpeedTestResult {
  const _SpeedTestResult({
    required this.downloadMbps,
    required this.uploadMbps,
  });

  final double downloadMbps;
  final double uploadMbps;
}
