import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

/// Read-only snapshot of the current network's identifying details.
class NetworkDetails {
  const NetworkDetails({
    this.ipAddress,
    this.wifiName,
  });

  final String? ipAddress;
  final String? wifiName;
}

/// Retrieves local network details (device IP, Wi-Fi SSID) using only
/// on-device APIs.
///
/// Does not require location permission unless the underlying OS
/// mandates it for SSID retrieval. If permission is refused or the
/// SSID cannot be read, the app simply returns null for wifiName.
class NetworkInfoService {
  NetworkInfoService({
    NetworkInfo? networkInfo,
  }) : _networkInfo = networkInfo ?? NetworkInfo();

  final NetworkInfo _networkInfo;

  Future<NetworkDetails> fetchDetails() async {
    final ip = await _resolveDeviceIp();

    String? wifiName;

    try {
      wifiName = await _networkInfo.getWifiName();

      // Some platforms wrap the SSID in quotes.
      // Use ?. because wifiName can be null.
      wifiName = wifiName?.replaceAll('"', '');
    } catch (_) {
      wifiName = null;
    }

    return NetworkDetails(
      ipAddress: ip,
      wifiName: wifiName,
    );
  }

  Future<String?> _resolveDeviceIp() async {
    try {
      final ip = await _networkInfo.getWifiIP();

      if (ip != null && ip.isNotEmpty) {
        return ip;
      }
    } catch (_) {
      // Fall through to interface lookup.
    }

    try {
      for (final interface in await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      )) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {
      // No IP available.
    }

    return null;
  }
}
