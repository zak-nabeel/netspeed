import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/speed_converter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/connection_chip.dart';
import '../../../../shared/widgets/speed_gauge.dart';
import '../../../network_info/presentation/providers/network_info_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/speed_test_state.dart';
import '../providers/speed_test_provider.dart';
import 'results_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final testState = ref.watch(speedTestProvider);
    final liveNetworkType = ref.watch(networkTypeProvider);
    final unit = ref.watch(settingsProvider).speedUnit;

    ref.listen(speedTestProvider, (previous, next) {
      if (next.phase == SpeedTestPhase.completed && previous?.phase != SpeedTestPhase.completed) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ResultsScreen()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l10n.networkInformation,
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.networkInfo),
          ),
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: testState.phase == SpeedTestPhase.error
            ? _ErrorView(state: testState)
            : _MainView(
                state: testState,
                connectionType: liveNetworkType.value ?? testState.connectionType,
                unit: unit,
              ),
      ),
    );
  }
}

class _MainView extends ConsumerWidget {
  const _MainView({required this.state, required this.connectionType, required this.unit});

  final SpeedTestState state;
  final NetworkType connectionType;
  final SpeedUnit unit;

  String _phaseCaption(AppLocalizations l10n) {
    switch (state.phase) {
      case SpeedTestPhase.checkingConnection:
      case SpeedTestPhase.findingServer:
      case SpeedTestPhase.idle:
      case SpeedTestPhase.completed:
      case SpeedTestPhase.cancelled:
      case SpeedTestPhase.error:
        return '';
      case SpeedTestPhase.testingPing:
        return l10n.statePing;
      case SpeedTestPhase.testingDownload:
        return l10n.stateDownload;
      case SpeedTestPhase.testingUpload:
        return l10n.stateUpload;
    }
  }

  String _gaugeValue() {
    switch (state.phase) {
      case SpeedTestPhase.testingPing:
        return state.pingMs.toStringAsFixed(0);
      case SpeedTestPhase.testingDownload:
        return SpeedConverter.format(state.currentDownloadMbps, unit);
      case SpeedTestPhase.testingUpload:
        return SpeedConverter.format(state.currentUploadMbps, unit);
      default:
        return SpeedConverter.format(0, unit);
    }
  }

  String _gaugeUnitLabel(AppLocalizations l10n) {
    if (state.phase == SpeedTestPhase.testingPing) return l10n.ms;
    return SpeedConverter.unitLabel(unit);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(speedTestProvider.notifier);
    final isRunning = state.isRunning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            l10n.appTagline,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          ConnectionChip(type: connectionType),
          const Spacer(),
          SpeedGauge(
            value: _gaugeValue(),
            unitLabel: _gaugeUnitLabel(l10n),
            progress: isRunning ? state.progress : null,
            caption: isRunning ? _phaseCaption(l10n) : null,
          ),
          const SizedBox(height: 12),
          if (isRunning) _StatusLine(state: state, l10n: l10n),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: isRunning
                ? OutlinedButton.icon(
                    onPressed: notifier.cancelTest,
                    icon: const Icon(Icons.close_rounded),
                    label: Text(l10n.cancelTest),
                  )
                : FilledButton(
                    onPressed: notifier.startTest,
                    child: Text(l10n.startTest),
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state, required this.l10n});

  final SpeedTestState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    String text;
    switch (state.phase) {
      case SpeedTestPhase.checkingConnection:
        text = l10n.stateCheckingConnection;
        break;
      case SpeedTestPhase.findingServer:
        text = l10n.stateFindingServer;
        break;
      case SpeedTestPhase.testingDownload:
        text = '${l10n.downloading} ${(state.progress * 100).toStringAsFixed(0)}%';
        break;
      case SpeedTestPhase.testingUpload:
        text = '${l10n.uploading} ${(state.progress * 100).toStringAsFixed(0)}%';
        break;
      default:
        text = '';
    }
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.state});

  final SpeedTestState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(speedTestProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final isNoInternet = state.error is NoInternetException;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNoInternet ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              size: 72,
              color: scheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              isNoInternet ? l10n.noInternetTitle : l10n.genericErrorTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.messageKey == 'noInternetMessage'
                  ? l10n.noInternetMessage
                  : state.error?.messageKey == 'timeoutErrorMessage'
                      ? l10n.timeoutErrorMessage
                      : state.error?.messageKey == 'connectionLostMessage'
                          ? l10n.connectionLostMessage
                          : l10n.serverErrorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  notifier.reset();
                  notifier.startTest();
                },
                child: Text(l10n.tryAgain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
