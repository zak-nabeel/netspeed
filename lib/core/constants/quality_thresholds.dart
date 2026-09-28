/// Quality rating for a measured value (ping, download or upload).
enum SpeedQuality { excellent, veryGood, good, fair, poor }

/// Centralised, easily editable thresholds used to translate raw
/// ping/download/upload numbers into a human quality rating.
///
/// Adjust the values below to change how the app rates connection quality
/// anywhere in the UI - nothing else needs to change.
class QualityThresholds {
  QualityThresholds._();

  // ---- Ping (milliseconds). Lower is better. ----
  static const double pingExcellentMax = 30;
  static const double pingGoodMax = 60;
  static const double pingFairMax = 100;
  // Anything above pingFairMax is poor.

  // ---- Download (Mbps). Higher is better. ----
  static const double downloadExcellentMin = 100;
  static const double downloadVeryGoodMin = 50;
  static const double downloadGoodMin = 20;
  static const double downloadFairMin = 5;
  // Anything below downloadFairMin is poor.

  // ---- Upload (Mbps). Higher is better. ----
  static const double uploadExcellentMin = 20;
  static const double uploadGoodMin = 10;
  static const double uploadFairMin = 5;
  // Anything below uploadFairMin is poor.

  static SpeedQuality ratePing(double ms) {
    if (ms <= pingExcellentMax) return SpeedQuality.excellent;
    if (ms <= pingGoodMax) return SpeedQuality.good;
    if (ms <= pingFairMax) return SpeedQuality.fair;
    return SpeedQuality.poor;
  }

  static SpeedQuality rateDownload(double mbps) {
    if (mbps >= downloadExcellentMin) return SpeedQuality.excellent;
    if (mbps >= downloadVeryGoodMin) return SpeedQuality.veryGood;
    if (mbps >= downloadGoodMin) return SpeedQuality.good;
    if (mbps >= downloadFairMin) return SpeedQuality.fair;
    return SpeedQuality.poor;
  }

  static SpeedQuality rateUpload(double mbps) {
    if (mbps >= uploadExcellentMin) return SpeedQuality.excellent;
    if (mbps >= uploadGoodMin) return SpeedQuality.good;
    if (mbps >= uploadFairMin) return SpeedQuality.fair;
    return SpeedQuality.poor;
  }
}
