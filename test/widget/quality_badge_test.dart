import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netspeed/core/constants/quality_thresholds.dart';
import 'package:netspeed/l10n/generated/app_localizations.dart';
import 'package:netspeed/shared/widgets/quality_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('QualityBadge shows "Excellent" for excellent quality', (tester) async {
    await tester.pumpWidget(_wrap(const QualityBadge(quality: SpeedQuality.excellent)));
    await tester.pumpAndSettle();
    expect(find.text('Excellent'), findsOneWidget);
  });

  testWidgets('QualityBadge shows "Poor" for poor quality', (tester) async {
    await tester.pumpWidget(_wrap(const QualityBadge(quality: SpeedQuality.poor)));
    await tester.pumpAndSettle();
    expect(find.text('Poor'), findsOneWidget);
  });
}
