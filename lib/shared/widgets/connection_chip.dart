import 'package:flutter/material.dart';

import '../../core/services/connectivity_service.dart';
import '../../l10n/generated/app_localizations.dart';

IconData connectionTypeIcon(NetworkType type) {
  switch (type) {
    case NetworkType.wifi:
      return Icons.wifi_rounded;
    case NetworkType.mobile:
      return Icons.signal_cellular_alt_rounded;
    case NetworkType.ethernet:
      return Icons.settings_ethernet_rounded;
    case NetworkType.none:
      return Icons.wifi_off_rounded;
    case NetworkType.unknown:
      return Icons.device_unknown_rounded;
  }
}

String connectionTypeLabel(AppLocalizations l10n, NetworkType type) {
  switch (type) {
    case NetworkType.wifi:
      return l10n.connectionWifi;
    case NetworkType.mobile:
      return l10n.connectionMobile;
    case NetworkType.ethernet:
      return l10n.connectionEthernet;
    case NetworkType.none:
      return l10n.connectionNone;
    case NetworkType.unknown:
      return l10n.connectionUnknown;
  }
}

/// Small pill shown at the top of the home screen with the current
/// connection type (Wi-Fi / Mobile Data / ...).
class ConnectionChip extends StatelessWidget {
  const ConnectionChip({super.key, required this.type});

  final NetworkType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(connectionTypeIcon(type), size: 18, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            connectionTypeLabel(l10n, type),
            style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface),
          ),
        ],
      ),
    );
  }
}
