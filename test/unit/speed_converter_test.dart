import 'package:flutter_test/flutter_test.dart';
import 'package:netspeed/core/utils/speed_converter.dart';

void main() {
  group('SpeedConverter', () {
    test('Mbps passes through unchanged', () {
      expect(SpeedConverter.convertFromMbps(80, SpeedUnit.mbps), 80);
    });

    test('converts Mbps to MB/s using 1 Byte = 8 bits', () {
      expect(SpeedConverter.convertFromMbps(80, SpeedUnit.mBps), 10);
    });

    test('format renders two decimal places', () {
      expect(SpeedConverter.format(125.4, SpeedUnit.mbps), '125.40');
      expect(SpeedConverter.format(80, SpeedUnit.mBps), '10.00');
    });

    test('unit labels are correct', () {
      expect(SpeedConverter.unitLabel(SpeedUnit.mbps), 'Mbps');
      expect(SpeedConverter.unitLabel(SpeedUnit.mBps), 'MB/s');
    });

    test('zero converts to zero in both units', () {
      expect(SpeedConverter.convertFromMbps(0, SpeedUnit.mbps), 0);
      expect(SpeedConverter.convertFromMbps(0, SpeedUnit.mBps), 0);
    });
  });
}
