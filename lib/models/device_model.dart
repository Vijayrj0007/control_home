import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'device_model.g.dart';

@HiveType(typeId: 0)
enum DeviceType {
  @HiveField(0)
  fan,
  @HiveField(1)
  ac,
  @HiveField(2)
  light,
  @HiveField(3)
  bulb,
  @HiveField(4)
  purifier,
  @HiveField(5)
  climate,
  @HiveField(6)
  thermostat
}

@HiveType(typeId: 1)
class Device extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DeviceType type;

  @HiveField(3)
  String room;

  @HiveField(4)
  bool isOn;

  @HiveField(5)
  DeviceSettings settings;

  Device({
    String? id,
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    DeviceSettings? settings,
  }) : id = id ?? const Uuid().v4(),
       settings = settings ?? DeviceSettings();

  Device copyWith({
    String? name,
    DeviceType? type,
    String? room,
    bool? isOn,
    DeviceSettings? settings,
  }) {
    return Device(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      room: room ?? this.room,
      isOn: isOn ?? this.isOn,
      settings: settings ?? this.settings,
    );
  }
}

@HiveType(typeId: 2)
class DeviceSettings extends HiveObject {
  @HiveField(0)
  int? brightness;

  @HiveField(1)
  int? temperature;

  @HiveField(2)
  int? fanSpeed;

  @HiveField(3)
  int? humidity;

  DeviceSettings({
    this.brightness,
    this.temperature,
    this.fanSpeed,
    this.humidity,
  });

  DeviceSettings copyWith({
    int? brightness,
    int? temperature,
    int? fanSpeed,
    int? humidity,
  }) {
    return DeviceSettings(
      brightness: brightness ?? this.brightness,
      temperature: temperature ?? this.temperature,
      fanSpeed: fanSpeed ?? this.fanSpeed,
      humidity: humidity ?? this.humidity,
    );
  }
}
