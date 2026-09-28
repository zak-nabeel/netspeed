/// The unit the user has chosen to display speeds in.
enum SpeedUnit { mbps, mBps }

/// Pure, well-tested conversion helpers for speed values.
///
/// 1 Byte = 8 bits, therefore MB/s = Mbps / 8.
class SpeedConverter {
  SpeedConverter._();

  static const double _bitsPerByte = 8;

  /// Converts a value already expressed in Mbps into the requested [unit].
  static double convertFromMbps(double mbps, SpeedUnit unit) {
    switch (unit) {
      case SpeedUnit.mbps:
        return mbps;
      case SpeedUnit.mBps:
        return mbps / _bitsPerByte;
    }
  }

  /// Formats a Mbps value for display in the given [unit], with 2 decimals.
  static String format(double mbps, SpeedUnit unit) {
    final converted = convertFromMbps(mbps, unit);
    return converted.toStringAsFixed(2);
  }

  /// Short unit label, e.g. "Mbps" or "MB/s".
  static String unitLabel(SpeedUnit unit) {
    switch (unit) {
      case SpeedUnit.mbps:
        return 'Mbps';
      case SpeedUnit.mBps:
        return 'MB/s';
    }
  }
}
