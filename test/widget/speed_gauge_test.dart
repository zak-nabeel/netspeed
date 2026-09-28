import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netspeed/shared/widgets/speed_gauge.dart';

void main() {
  testWidgets('SpeedGauge shows the formatted value and unit label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpeedGauge(
            value: '00.00',
            unitLabel: 'Mbps',
          ),
        ),
      ),
    );

    expect(find.text('00.00'), findsOneWidget);
    expect(find.text('Mbps'), findsOneWidget);
  });

  testWidgets('SpeedGauge shows a phase caption when provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpeedGauge(
            value: '125.40',
            unitLabel: 'Mbps',
            progress: 0.6,
            caption: 'DOWNLOAD',
          ),
        ),
      ),
    );

    expect(find.text('DOWNLOAD'), findsOneWidget);
    expect(find.text('125.40'), findsOneWidget);

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, 0.6);
  });

  testWidgets('SpeedGauge shows an indeterminate ring when progress is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpeedGauge(value: '00.00', unitLabel: 'Mbps'),
        ),
      ),
    );

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, isNull);
  });
}
