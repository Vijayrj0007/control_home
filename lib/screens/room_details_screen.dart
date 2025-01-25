import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';

class RoomDetailsScreen extends StatelessWidget {
  final String room;

  const RoomDetailsScreen({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D1F),
      appBar: AppBar(
        title: Text(room),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          final devices = deviceProvider.getDevicesByRoom(room);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: devices.length + 1, // +1 for add device button
              itemBuilder: (context, index) {
                if (index == devices.length) {
                  return _buildAddDeviceCard(context);
                }
                return _buildDeviceCard(context, devices[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, Device device) {
    const iconSize = 32.0;
    const cardColor = Color(0xFF2C2F33);
    final activeColor = Theme.of(context).colorScheme.primary;
    final isActive = device.isOn;
    
    IconData getDeviceTypeIcon(DeviceType type) {
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

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  getDeviceTypeIcon(device.type),
                  color: isActive ? activeColor : Colors.white54,
                  size: iconSize,
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) => _toggleDevice(context, device),
                  activeColor: activeColor,
                ),
              ],
            ),
            const Spacer(),
            Text(
              device.name,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isActive ? 'On' : 'Off',
              style: TextStyle(
                color: isActive ? activeColor : Colors.white38,
                fontSize: 14,
              ),
            ),
            if (device.type == DeviceType.climate) ...[
              const SizedBox(height: 8),
              Text(
                '${device.settings.temperature ?? 24}°C',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddDeviceCard(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2F33),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showAddDeviceDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: const Center(
          child: Icon(
            Icons.add_circle_outline,
            color: Colors.white54,
            size: 32,
          ),
        ),
      ),
    );
  }

  void _toggleDevice(BuildContext context, Device device) {
    context.read<DeviceProvider>().toggleDevice(device.id, !device.isOn);
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddDeviceDialog(room: room),
    );
  }
}

class AddDeviceDialog extends StatefulWidget {
  final String room;

  const AddDeviceDialog({
    super.key,
    required this.room,
  });

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DeviceType _selectedType = DeviceType.light;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2C2F33),
      title: const Text(
        'Add Device',
        style: TextStyle(color: Colors.white),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a device name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DeviceType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Device Type',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              dropdownColor: const Color(0xFF2C2F33),
              style: const TextStyle(color: Colors.white),
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
        room: widget.room,
      );
      context.read<DeviceProvider>().addDevice(device);
      Navigator.pop(context);
    }
  }
}
