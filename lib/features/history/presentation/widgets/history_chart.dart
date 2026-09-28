import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../speed_test/domain/entities/speed_test_result.dart';
import '../providers/history_provider.dart';

class HistoryChart extends StatelessWidget {
  const HistoryChart({super.key, required this.results, required this.metric});

  /// Most-recent-first list of results (as returned by the repository).
  final List<SpeedTestResult> results;
  final ChartMetric metric;

  double _valueFor(SpeedTestResult r) {
    switch (metric) {
      case ChartMetric.download:
        return r.downloadMbps;
      case ChartMetric.upload:
        return r.uploadMbps;
      case ChartMetric.ping:
        return r.pingMs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Chart wants chronological (oldest -> newest) order, most recent N.
    final recent = results.take(AppConstants.chartEntryCount).toList().reversed.toList();

    if (recent.length < 2) {
      return Center(
        child: Text(
          '—',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 24),
        ),
      );
    }

    final spots = <FlSpot>[
      for (var i = 0; i < recent.length; i++) FlSpot(i.toDouble(), _valueFor(recent[i])),
    ];
    final maxY = spots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY <= 0 ? 10 : maxY * 1.2,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY <= 0 ? 10 : maxY * 1.2) / 4,
          getDrawingHorizontalLine: (_) => FlLine(color: scheme.outlineVariant, strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => scheme.inverseSurface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((s) {
                return LineTooltipItem(
                  s.y.toStringAsFixed(1),
                  TextStyle(color: scheme.onInverseSurface, fontWeight: FontWeight.w700),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: scheme.primary,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: scheme.primary.withOpacity(0.12)),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}
