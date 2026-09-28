import 'package:flutter/material.dart';

/// The big circular gauge used on the home screen (idle "00.00 Mbps") and
/// during the test (animated ring + live value).
class SpeedGauge extends StatelessWidget {
  const SpeedGauge({
    super.key,
    required this.value,
    required this.unitLabel,
    this.progress,
    this.size = 260,
    this.caption,
  });

  /// The number to display in the center, already formatted (e.g. "125.40").
  final String value;
  final String unitLabel;

  /// 0.0 - 1.0 progress of the current phase, or null for an indeterminate
  /// / idle ring.
  final double? progress;
  final double size;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(scheme.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (caption != null) ...[
                Text(
                  caption!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 8),
              ],
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Text(
                  value,
                  key: ValueKey(value),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                unitLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
