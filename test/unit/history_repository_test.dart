import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netspeed/core/services/connectivity_service.dart';
import 'package:netspeed/features/history/data/models/history_item_model.dart';
import 'package:netspeed/features/history/data/repositories/history_repository_impl.dart';
import 'package:netspeed/features/speed_test/domain/entities/speed_test_result.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProviderPlatform extends PlatformInterface
    implements PathProviderPlatform {
  _FakePathProviderPlatform() : super(token: _token);
  static final Object _token = Object();

  @override
  Future<String?> getTemporaryPath() async => '.dart_tool/test_hive';

  @override
  Future<String?> getApplicationSupportPath() async => '.dart_tool/test_hive';

  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_tool/test_hive';

  @override
  Future<String?> getDownloadsPath() async => '.dart_tool/test_hive';

  @override
  Future<String?> getExternalStoragePath() async => '.dart_tool/test_hive';

  @override
  Future<List<String>?> getExternalCachePaths() async => ['.dart_tool/test_hive'];

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) async =>
      ['.dart_tool/test_hive'];

  @override
  Future<String?> getLibraryPath() async => '.dart_tool/test_hive';
}

SpeedTestResult _sampleResult({double download = 100, double upload = 20, double ping = 25}) {
  return SpeedTestResult(
    id: 'id-${DateTime.now().microsecondsSinceEpoch}',
    timestamp: DateTime.now(),
    downloadMbps: download,
    uploadMbps: upload,
    pingMs: ping,
    connectionType: NetworkType.wifi,
    wifiName: 'Home Wi-Fi',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = _FakePathProviderPlatform();

  setUp(() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(HistoryItemModelAdapter().typeId)) {
      Hive.registerAdapter(HistoryItemModelAdapter());
    }
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('add() persists a result retrievable via getAll()', () async {
    final box = await Hive.openBox<HistoryItemModel>('test_history_box_1');
    final repo = HistoryRepositoryImpl(box: box);

    final result = _sampleResult();
    await repo.add(result);

    final all = await repo.getAll();
    expect(all, hasLength(1));
    expect(all.first.downloadMbps, result.downloadMbps);
    expect(all.first.uploadMbps, result.uploadMbps);
    expect(all.first.pingMs, result.pingMs);
    expect(all.first.connectionType, NetworkType.wifi);
    expect(all.first.wifiName, 'Home Wi-Fi');

    await box.close();
  });

  test('getAll() returns items most-recent-first', () async {
    final box = await Hive.openBox<HistoryItemModel>('test_history_box_2');
    final repo = HistoryRepositoryImpl(box: box);

    final older = SpeedTestResult(
      id: 'old',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      downloadMbps: 50,
      uploadMbps: 10,
      pingMs: 30,
      connectionType: NetworkType.mobile,
    );
    final newer = _sampleResult();

    await repo.add(older);
    await repo.add(newer);

    final all = await repo.getAll();
    expect(all.first.id, newer.id);
    expect(all.last.id, older.id);

    await box.close();
  });

  test('clear() removes every saved result', () async {
    final box = await Hive.openBox<HistoryItemModel>('test_history_box_3');
    final repo = HistoryRepositoryImpl(box: box);

    await repo.add(_sampleResult());
    await repo.add(_sampleResult());
    expect(await repo.getAll(), hasLength(2));

    await repo.clear();
    expect(await repo.getAll(), isEmpty);

    await box.close();
  });
}
