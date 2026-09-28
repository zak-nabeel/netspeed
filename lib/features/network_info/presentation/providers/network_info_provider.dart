import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/network_info_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final networkInfoServiceProvider = Provider<NetworkInfoService>((ref) {
  return NetworkInfoService();
});

/// Live network type (Wi-Fi / Mobile / none), used on the home screen.
final networkTypeProvider = StreamProvider<NetworkType>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onTypeChanged;
});

/// One-shot fetch of IP address / Wi-Fi name for the Network Info screen.
final networkDetailsProvider = FutureProvider.autoDispose<NetworkDetails>((ref) async {
  final service = ref.watch(networkInfoServiceProvider);
  return service.fetchDetails();
});

/// Whether there is currently real internet access (not just link state).
final hasInternetProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(connectivityServiceProvider);
  return service.hasRealInternetAccess();
});
