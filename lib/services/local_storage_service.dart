import 'package:hive_flutter/hive_flutter.dart';
import '../models/device_model.dart';
import 'package:logger/logger.dart';

class LocalStorageService {
  static const String _deviceBoxName = 'devices';
  final Logger _logger = Logger();
  late Box<Device> _deviceBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DeviceTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DeviceAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(DeviceSettingsAdapter());
    }

    _deviceBox = await Hive.openBox<Device>(_deviceBoxName);
  }

  Future<List<Device>> getDevices() async {
    try {
      return _deviceBox.values.toList();
    } catch (e) {
      _logger.e('Error getting devices: $e');
      return [];
    }
  }

  Future<void> addDevice(Device device) async {
    try {
      await _deviceBox.put(device.id, device);
      _logger.i('Added device: ${device.id}');
    } catch (e) {
      _logger.e('Error adding device: $e');
      rethrow;
    }
  }

  Future<void> updateDevice(Device device) async {
    try {
      await _deviceBox.put(device.id, device);
      _logger.i('Updated device: ${device.id}');
    } catch (e) {
      _logger.e('Error updating device: $e');
      rethrow;
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      await _deviceBox.delete(deviceId);
      _logger.i('Deleted device: $deviceId');
    } catch (e) {
      _logger.e('Error deleting device: $e');
      rethrow;
    }
  }

  Future<List<Device>> getDevicesByRoom(String room) async {
    try {
      return _deviceBox.values.where((device) => device.room == room).toList();
    } catch (e) {
      _logger.e('Error getting devices by room: $e');
      return [];
    }
  }

  Future<List<Device>> getDevicesByType(DeviceType type) async {
    try {
      return _deviceBox.values.where((device) => device.type == type).toList();
    } catch (e) {
      _logger.e('Error getting devices by type: $e');
      return [];
    }
  }

  Future<void> toggleDevice(String deviceId, bool isOn) async {
    try {
      final device = _deviceBox.get(deviceId);
      if (device != null) {
        device.isOn = isOn;
        await device.save();
        _logger.i('Toggled device $deviceId to ${isOn ? 'on' : 'off'}');
      }
    } catch (e) {
      _logger.e('Error toggling device: $e');
      rethrow;
    }
  }

  Future<void> updateDeviceSettings(String deviceId, DeviceSettings settings) async {
    try {
      final device = _deviceBox.get(deviceId);
      if (device != null) {
        device.settings = settings;
        await device.save();
        _logger.i('Updated settings for device: $deviceId');
      }
    } catch (e) {
      _logger.e('Error updating device settings: $e');
      rethrow;
    }
  }
}
