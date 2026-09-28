import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants/app_constants.dart';

/// The kind of network interface currently in use.
enum NetworkType { wifi, mobile, ethernet, none, unknown }

/// Wraps [Connectivity] and adds a *real* internet-reachability probe,
/// because being associated with a Wi-Fi access point does not guarantee
/// that access point actually has internet behind it.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Stream of network *type* changes (does not guarantee internet access).
  Stream<NetworkType> get onTypeChanged =>
      _connectivity.onConnectivityChanged.map(_mapResults);

  Future<NetworkType> currentType() async {
    final results = await _connectivity.checkConnectivity();
    return _mapResults(results);
  }

  NetworkType _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) return NetworkType.wifi;
    if (results.contains(ConnectivityResult.mobile)) return NetworkType.mobile;
    if (results.contains(ConnectivityResult.ethernet)) return NetworkType.ethernet;
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkType.none;
    }
    return NetworkType.unknown;
  }

  /// Confirms there is an actual, working internet connection by opening a
  /// lightweight HTTPS connection - not just checking the OS-reported
  /// network state, since Wi-Fi with no internet still reports "connected".
  Future<bool> hasRealInternetAccess() async {
    final type = await currentType();
    if (type == NetworkType.none) return false;

    try {
      final client = HttpClient()..connectionTimeout = AppConstants.connectivityCheckTimeout;
      final request = await client
          .getUrl(Uri.parse(AppConstants.connectivityProbeUrl))
          .timeout(AppConstants.connectivityCheckTimeout);
      final response = await request.close().timeout(AppConstants.connectivityCheckTimeout);
      await response.drain<void>();
      client.close(force: true);
      // 204/200 both indicate a live path to the internet.
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
