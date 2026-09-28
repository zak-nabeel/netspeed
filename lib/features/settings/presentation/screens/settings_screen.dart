import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/utils/speed_converter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel(l10n.theme),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeSystem),
                  value: ThemeMode.system,
                  groupValue: settings.themeMode,
                  onChanged: (v) => notifier.setThemeMode(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeLight),
                  value: ThemeMode.light,
                  groupValue: settings.themeMode,
                  onChanged: (v) => notifier.setThemeMode(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeDark),
                  value: ThemeMode.dark,
                  groupValue: settings.themeMode,
                  onChanged: (v) => notifier.setThemeMode(v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(l10n.speedUnit),
          Card(
            child: Column(
              children: [
                RadioListTile<SpeedUnit>(
                  title: Text(l10n.unitMbps),
                  value: SpeedUnit.mbps,
                  groupValue: settings.speedUnit,
                  onChanged: (v) => notifier.setSpeedUnit(v!),
                ),
                RadioListTile<SpeedUnit>(
                  title: Text(l10n.unitMBps),
                  value: SpeedUnit.mBps,
                  groupValue: settings.speedUnit,
                  onChanged: (v) => notifier.setSpeedUnit(v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(l10n.language),
          Card(
            child: Column(
              children: [
                RadioListTile<Locale>(
                  title: const Text('English'),
                  value: const Locale('en'),
                  groupValue: settings.locale,
                  onChanged: (v) => notifier.setLocale(v!),
                ),
                RadioListTile<Locale>(
                  title: const Text('العربية'),
                  value: const Locale('ar'),
                  groupValue: settings.locale,
                  onChanged: (v) => notifier.setLocale(v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(l10n.clearHistory),
              onTap: () async {
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
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.clearHistory)),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.privacy),
                  onTap: () => _showInfoSheet(context, l10n.privacy, l10n.privacyBody, l10n),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(l10n.about),
                  onTap: () => _showInfoSheet(context, l10n.about, l10n.aboutBody, l10n),
                ),
                const Divider(height: 1),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '1.0.0';
                    return ListTile(
                      leading: const Icon(Icons.tag_rounded),
                      title: Text(l10n.appVersion),
                      trailing: Text(version),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String body, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(body, style: Theme.of(ctx).textTheme.bodyMedium),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
