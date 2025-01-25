import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../services/local_storage_service.dart';

class DeviceProvider with ChangeNotifier {
  final LocalStorageService _storageService;
  List<Device> _devices = [];

  DeviceProvider(this._storageService) {
    _loadDevices();
  }

  List<Device> get devices => _devices;

  Future<void> _loadDevices() async {
    _devices = await _storageService.getDevices();
    notifyListeners();
  }

  List<Device> getDevicesByRoom(String room) {
    return _devices.where((device) => device.room == room).toList();
  }

  Future<void> addDevice(Device device) async {
    await _storageService.addDevice(device);
    await _loadDevices();
  }

  Future<void> updateDevice(Device device) async {
    await _storageService.updateDevice(device);
    await _loadDevices();
  }

  Future<void> deleteDevice(String id) async {
    await _storageService.deleteDevice(id);
    await _loadDevices();
  }

  Future<void> toggleDevice(String id, bool isOn) async {
    final deviceIndex = _devices.indexWhere((d) => d.id == id);
    if (deviceIndex != -1) {
      final device = _devices[deviceIndex];
      final updatedDevice = device.copyWith(isOn: isOn);
      await updateDevice(updatedDevice);
    }
  }

  Future<void> updateDeviceSettings(String id, DeviceSettings settings) async {
    final deviceIndex = _devices.indexWhere((d) => d.id == id);
    if (deviceIndex != -1) {
      final device = _devices[deviceIndex];
      final updatedDevice = device.copyWith(settings: settings);
      await updateDevice(updatedDevice);
    }
  }

  Future<void> setBrightness(String id, int brightness) async {
    final deviceIndex = _devices.indexWhere((d) => d.id == id);
    if (deviceIndex != -1) {
      final device = _devices[deviceIndex];
      final newSettings = device.settings.copyWith(brightness: brightness);
      await updateDeviceSettings(id, newSettings);
    }
  }

  Future<void> setTemperature(String id, int temperature) async {
    final deviceIndex = _devices.indexWhere((d) => d.id == id);
    if (deviceIndex != -1) {
      final device = _devices[deviceIndex];
      final newSettings = device.settings.copyWith(temperature: temperature);
      await updateDeviceSettings(id, newSettings);
    }
  }

  Future<void> setFanSpeed(String id, int speed) async {
    final deviceIndex = _devices.indexWhere((d) => d.id == id);
    if (deviceIndex != -1) {
      final device = _devices[deviceIndex];
      final newSettings = device.settings.copyWith(fanSpeed: speed);
      await updateDeviceSettings(id, newSettings);
    }
  }

  Future<void> setHumidity(String id, int humidity) async {
    final deviceIndex = _devices.indexWhere((d) => d.id == id);
    if (deviceIndex != -1) {
      final device = _devices[deviceIndex];
      final newSettings = device.settings.copyWith(humidity: humidity);
      await updateDeviceSettings(id, newSettings);
    }
  }

  // Get devices by type
  List<Device> getDevicesByType(DeviceType type) {
    return _devices.where((device) => device.type == type).toList();
  }
}
