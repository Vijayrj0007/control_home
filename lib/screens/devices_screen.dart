import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, deviceProvider, child) {
        final devices = deviceProvider.devices;

        if (devices.isEmpty) {
          return const Center(
            child: Text('No devices found. Add a device to get started!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: devices.length + 1, // +1 for add device button
          itemBuilder: (context, index) {
            if (index == devices.length) {
              return _buildAddDeviceCard(context);
            }
            return _buildDeviceCard(context, devices[index]);
          },
        );
      },
    );
  }

  Widget _buildDeviceCard(BuildContext context, Device device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getDeviceIcon(device.type),
                      color: device.isOn ? Theme.of(context).colorScheme.primary : Colors.white54,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          device.room,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: device.isOn,
                  onChanged: (value) {
                    context.read<DeviceProvider>().toggleDevice(device.id, value);
                  },
                ),
              ],
            ),
            if (device.settings.temperature != null) ...[
              const SizedBox(height: 8),
              Text(
                'Temperature: ${device.settings.temperature}°C',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (device.settings.fanSpeed != null) ...[
              const SizedBox(height: 8),
              Text(
                'Fan Speed: ${device.settings.fanSpeed}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (device.settings.brightness != null) ...[
              const SizedBox(height: 8),
              Text(
                'Brightness: ${device.settings.brightness}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (device.settings.humidity != null) ...[
              const SizedBox(height: 8),
              Text(
                'Humidity: ${device.settings.humidity}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_outline;
      case DeviceType.fan:
        return Icons.wind_power;
      case DeviceType.ac:
        return Icons.ac_unit;
      case DeviceType.bulb:
        return Icons.lightbulb;
      case DeviceType.purifier:
        return Icons.air;
      case DeviceType.climate:
        return Icons.thermostat;
      case DeviceType.thermostat:
        return Icons.thermostat_auto;
    }
  }

  Widget _buildAddDeviceCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showAddDeviceDialog(context),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline),
              SizedBox(width: 8),
              Text('Add Device'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddDeviceDialog(),
    );
  }
}

class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({super.key});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  DeviceType _selectedType = DeviceType.light;

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Device'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Device Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a device name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomController,
              decoration: const InputDecoration(labelText: 'Room'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a room name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DeviceType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Device Type'),
              items: DeviceType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final device = Device(
        name: _nameController.text,
        type: _selectedType,
        room: _roomController.text,
      );
      context.read<DeviceProvider>().addDevice(device);
      Navigator.pop(context);
    }
  }
}
