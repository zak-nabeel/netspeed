import 'package:flutter/material.dart';

import '../../core/constants/quality_thresholds.dart';
import '../../l10n/generated/app_localizations.dart';

/// Small colored pill communicating a [SpeedQuality] rating at a glance.
class QualityBadge extends StatelessWidget {
  const QualityBadge({super.key, required this.quality});

  final SpeedQuality quality;

  Color _color(BuildContext context) {
    switch (quality) {
      case SpeedQuality.excellent:
        return const Color(0xFF2E7D32);
      case SpeedQuality.veryGood:
        return const Color(0xFF558B2F);
      case SpeedQuality.good:
        return const Color(0xFF9E9D24);
      case SpeedQuality.fair:
        return const Color(0xFFEF6C00);
      case SpeedQuality.poor:
        return const Color(0xFFC62828);
    }
  }

  String _label(AppLocalizations l10n) {
    switch (quality) {
      case SpeedQuality.excellent:
        return l10n.qualityExcellent;
      case SpeedQuality.veryGood:
        return l10n.qualityVeryGood;
      case SpeedQuality.good:
        return l10n.qualityGood;
      case SpeedQuality.fair:
        return l10n.qualityFair;
      case SpeedQuality.poor:
        return l10n.qualityPoor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(l10n),
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
