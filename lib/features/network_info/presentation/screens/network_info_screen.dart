import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/connection_chip.dart';
import '../providers/network_info_provider.dart';

class NetworkInfoScreen extends ConsumerWidget {
  const NetworkInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final networkType = ref.watch(networkTypeProvider);
    final hasInternet = ref.watch(hasInternetProvider);
    final details = ref.watch(networkDetailsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.networkInformation)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(hasInternetProvider);
          ref.invalidate(networkDetailsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _InfoTile(
              icon: Icons.wifi_rounded,
              label: l10n.connectionType,
              value: networkType.when(
                data: (type) => connectionTypeLabel(l10n, type),
                loading: () => '…',
                error: (_, __) => l10n.connectionUnknown,
              ),
            ),
            _InfoTile(
              icon: Icons.public_rounded,
              label: l10n.internetStatus,
              value: hasInternet.when(
                data: (ok) => ok ? l10n.connected : l10n.disconnected,
                loading: () => '…',
                error: (_, __) => l10n.disconnected,
              ),
              valueColor: hasInternet.maybeWhen(
                data:
                    (ok) =>
                        ok ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                orElse: () => null,
              ),
            ),
            _InfoTile(
              icon: Icons.language_rounded,
              label: l10n.ipAddress,
              value: details.when(
                data: (d) => d.ipAddress ?? l10n.notAvailable,
                loading: () => '…',
                error: (_, __) => l10n.notAvailable,
              ),
            ),
            _InfoTile(
              icon: Icons.router_rounded,
              label: l10n.wifiName,
              value: details.when(
                data: (d) => d.wifiName ?? l10n.notAvailable,
                loading: () => '…',
                error: (_, __) => l10n.notAvailable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Icon(icon, color: scheme.onPrimaryContainer),
        ),
        title: Text(label, style: TextStyle(color: scheme.onSurfaceVariant)),
        subtitle: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: valueColor ?? scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
