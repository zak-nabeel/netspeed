import 'package:flutter_test/flutter_test.dart';
import 'package:netspeed/core/constants/quality_thresholds.dart';

void main() {
  group('QualityThresholds.ratePing', () {
    test('excellent below 30ms', () {
      expect(QualityThresholds.ratePing(15), SpeedQuality.excellent);
      expect(QualityThresholds.ratePing(30), SpeedQuality.excellent);
    });

    test('good between 30 and 60ms', () {
      expect(QualityThresholds.ratePing(45), SpeedQuality.good);
      expect(QualityThresholds.ratePing(60), SpeedQuality.good);
    });

    test('fair between 60 and 100ms', () {
      expect(QualityThresholds.ratePing(80), SpeedQuality.fair);
      expect(QualityThresholds.ratePing(100), SpeedQuality.fair);
    });

    test('poor above 100ms', () {
      expect(QualityThresholds.ratePing(150), SpeedQuality.poor);
    });
  });

  group('QualityThresholds.rateDownload', () {
    test('excellent at or above 100 Mbps', () {
      expect(QualityThresholds.rateDownload(100), SpeedQuality.excellent);
      expect(QualityThresholds.rateDownload(300), SpeedQuality.excellent);
    });

    test('very good between 50 and 100 Mbps', () {
      expect(QualityThresholds.rateDownload(70), SpeedQuality.veryGood);
    });

    test('good between 20 and 50 Mbps', () {
      expect(QualityThresholds.rateDownload(30), SpeedQuality.good);
    });

    test('fair between 5 and 20 Mbps', () {
      expect(QualityThresholds.rateDownload(10), SpeedQuality.fair);
    });

    test('poor below 5 Mbps', () {
      expect(QualityThresholds.rateDownload(2), SpeedQuality.poor);
    });
  });

  group('QualityThresholds.rateUpload', () {
    test('excellent at or above 20 Mbps', () {
      expect(QualityThresholds.rateUpload(25), SpeedQuality.excellent);
    });

    test('good between 10 and 20 Mbps', () {
      expect(QualityThresholds.rateUpload(15), SpeedQuality.good);
    });

    test('fair between 5 and 10 Mbps', () {
      expect(QualityThresholds.rateUpload(7), SpeedQuality.fair);
    });

    test('poor below 5 Mbps', () {
      expect(QualityThresholds.rateUpload(1), SpeedQuality.poor);
    });
  });
}
