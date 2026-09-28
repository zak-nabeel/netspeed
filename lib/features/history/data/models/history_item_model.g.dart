// GENERATED CODE - DO NOT MODIFY BY HAND
// This file mirrors exactly what `flutter pub run build_runner build`
// would generate from the @HiveType/@HiveField annotations in
// history_item_model.dart. It is checked in so the project builds and
// runs immediately without requiring a build_runner step.

part of 'history_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryItemModelAdapter extends TypeAdapter<HistoryItemModel> {
  @override
  final int typeId = 0;

  @override
  HistoryItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryItemModel(
      id: fields[0] as String,
      timestampMillis: fields[1] as int,
      downloadMbps: fields[2] as double,
      uploadMbps: fields[3] as double,
      pingMs: fields[4] as double,
      connectionTypeIndex: fields[5] as int,
      wifiName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestampMillis)
      ..writeByte(2)
      ..write(obj.downloadMbps)
      ..writeByte(3)
      ..write(obj.uploadMbps)
      ..writeByte(4)
      ..write(obj.pingMs)
      ..writeByte(5)
      ..write(obj.connectionTypeIndex)
      ..writeByte(6)
      ..write(obj.wifiName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
