import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/constants/quality_thresholds.dart';
import '../../../../core/utils/speed_converter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/connection_chip.dart';
import '../../../../shared/widgets/quality_badge.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/speed_test_provider.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(speedTestProvider);
    final unit = ref.watch(settingsProvider).speedUnit;
    final result = state.result;

    if (result == null) {
      // Defensive fallback - should not happen since we only navigate here
      // once a result exists.
      return Scaffold(body: Center(child: Text(l10n.genericErrorTitle)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.yourInternetSpeed)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ConnectionChip(type: result.connectionType),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _MetricCard(
                      icon: Icons.download_rounded,
                      label: l10n.download,
                      value: SpeedConverter.format(result.downloadMbps, unit),
                      unit: SpeedConverter.unitLabel(unit),
                      quality: QualityThresholds.rateDownload(result.downloadMbps),
                    ),
                    _MetricCard(
                      icon: Icons.upload_rounded,
                      label: l10n.upload,
                      value: SpeedConverter.format(result.uploadMbps, unit),
                      unit: SpeedConverter.unitLabel(unit),
                      quality: QualityThresholds.rateUpload(result.uploadMbps),
                    ),
                    _MetricCard(
                      icon: Icons.speed_rounded,
                      label: l10n.ping,
                      value: result.pingMs.toStringAsFixed(0),
                      unit: l10n.ms,
                      quality: QualityThresholds.ratePing(result.pingMs),
                    ),
                    _MetricCard(
                      icon: Icons.wifi_tethering_rounded,
                      label: l10n.connection,
                      value: connectionTypeLabel(l10n, result.connectionType),
                      unit: '',
                      quality: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.history),
                      child: Text(l10n.viewHistory),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref.read(speedTestProvider.notifier).reset();
                        Navigator.of(context).pop();
                        ref.read(speedTestProvider.notifier).startTest();
                      },
                      child: Text(l10n.testAgain),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.quality,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final SpeedQuality? quality;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.primary),
                const Spacer(),
                if (quality != null) QualityBadge(quality: quality!),
              ],
            ),
            const Spacer(),
            Text(label, style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(unit, style: TextStyle(color: scheme.onSurfaceVariant)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
