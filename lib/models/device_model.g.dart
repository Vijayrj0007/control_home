// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceTypeAdapter extends TypeAdapter<DeviceType> {
  @override
  final int typeId = 0;

  @override
  DeviceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeviceType.fan;
      case 1:
        return DeviceType.ac;
      case 2:
        return DeviceType.light;
      case 3:
        return DeviceType.bulb;
      case 4:
        return DeviceType.purifier;
      case 5:
        return DeviceType.climate;
      case 6:
        return DeviceType.thermostat;
      default:
        return DeviceType.light;
    }
  }

  @override
  void write(BinaryWriter writer, DeviceType obj) {
    switch (obj) {
      case DeviceType.fan:
        writer.writeByte(0);
        break;
      case DeviceType.ac:
        writer.writeByte(1);
        break;
      case DeviceType.light:
        writer.writeByte(2);
        break;
      case DeviceType.bulb:
        writer.writeByte(3);
        break;
      case DeviceType.purifier:
        writer.writeByte(4);
        break;
      case DeviceType.climate:
        writer.writeByte(5);
        break;
      case DeviceType.thermostat:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 1;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      id: fields[0] as String?,
      name: fields[1] as String,
      type: fields[2] as DeviceType,
      room: fields[3] as String,
      isOn: fields[4] as bool,
      settings: fields[5] as DeviceSettings?,
    );
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.room)
      ..writeByte(4)
      ..write(obj.isOn)
      ..writeByte(5)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceSettingsAdapter extends TypeAdapter<DeviceSettings> {
  @override
  final int typeId = 2;

  @override
  DeviceSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceSettings(
      brightness: fields[0] as int?,
      temperature: fields[1] as int?,
      fanSpeed: fields[2] as int?,
      humidity: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.brightness)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.fanSpeed)
      ..writeByte(3)
      ..write(obj.humidity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
