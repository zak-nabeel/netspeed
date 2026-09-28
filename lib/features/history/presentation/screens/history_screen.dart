import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/quality_thresholds.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/speed_converter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/connection_chip.dart';
import '../../../../shared/widgets/quality_badge.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../speed_test/domain/entities/speed_test_result.dart';
import '../providers/history_provider.dart';
import '../widgets/history_chart.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(historyListProvider);
    final unit = ref.watch(settingsProvider).speedUnit;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          historyAsync.maybeWhen(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: l10n.clearHistory,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => _confirmClear(context, ref, l10n),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text(l10n.genericErrorTitle)),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState(l10n: l10n);
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _ChartSection(results: items)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _HistoryTile(result: items[index], unit: unit, l10n: l10n),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearHistory),
        content: Text(l10n.clearHistoryConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true) {
      await clearAllHistory(ref);
    }
  }
}

class _ChartSection extends ConsumerWidget {
  const _ChartSection({required this.results});

  final List<SpeedTestResult> results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final metric = ref.watch(chartMetricProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<ChartMetric>(
                segments: [
                  ButtonSegment(value: ChartMetric.download, label: Text(l10n.download)),
                  ButtonSegment(value: ChartMetric.upload, label: Text(l10n.upload)),
                  ButtonSegment(value: ChartMetric.ping, label: Text(l10n.ping)),
                ],
                selected: {metric},
                onSelectionChanged: (selection) {
                  ref.read(chartMetricProvider.notifier).state = selection.first;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: HistoryChart(results: results, metric: metric),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.result, required this.unit, required this.l10n});

  final SpeedTestResult result;
  final SpeedUnit unit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('dd MMM yyyy • HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(connectionTypeIcon(result.connectionType), size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Text(
                  connectionTypeLabel(l10n, result.connectionType),
                  style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  dateFormat.format(result.timestamp),
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MiniMetric(
                  icon: Icons.download_rounded,
                  value: SpeedConverter.format(result.downloadMbps, unit),
                  unit: SpeedConverter.unitLabel(unit),
                  quality: QualityThresholds.rateDownload(result.downloadMbps),
                ),
                const SizedBox(width: 20),
                _MiniMetric(
                  icon: Icons.upload_rounded,
                  value: SpeedConverter.format(result.uploadMbps, unit),
                  unit: SpeedConverter.unitLabel(unit),
                  quality: QualityThresholds.rateUpload(result.uploadMbps),
                ),
                const SizedBox(width: 20),
                _MiniMetric(
                  icon: Icons.speed_rounded,
                  value: result.pingMs.toStringAsFixed(0),
                  unit: l10n.ms,
                  quality: QualityThresholds.ratePing(result.pingMs),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.icon,
    required this.value,
    required this.unit,
    required this.quality,
  });

  final IconData icon;
  final String value;
  final String unit;
  final SpeedQuality quality;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(height: 4),
          Text(
            '$value $unit',
            style: const TextStyle(fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          QualityBadge(quality: quality),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 64, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(l10n.noHistoryYet, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.noHistoryMessage,
              style: TextStyle(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
