import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../speed_test/presentation/providers/speed_test_provider.dart'
    show historyListProvider, historyRepositoryProvider;

export '../../../speed_test/presentation/providers/speed_test_provider.dart'
    show historyListProvider, historyRepositoryProvider;

/// Which metric is currently selected on the history chart.
enum ChartMetric { download, upload, ping }

final chartMetricProvider = StateProvider<ChartMetric>((ref) => ChartMetric.download);

/// Clears all saved history and refreshes [historyListProvider].
Future<void> clearAllHistory(WidgetRef ref) async {
  await ref.read(historyRepositoryProvider).clear();
  ref.invalidate(historyListProvider);
}
