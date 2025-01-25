import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';
import 'room_details_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, deviceProvider, child) {
        final rooms = _getRooms(deviceProvider.devices);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final devices = deviceProvider.devices
                  .where((d) => d.room == room)
                  .toList();
              return _buildRoomCard(context, room, devices);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddRoomDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  List<String> _getRooms(List<Device> devices) {
    return devices.map((d) => d.room).toSet().toList()..sort();
  }

  Widget _buildRoomCard(BuildContext context, String room, List<Device> devices) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailsScreen(room: room),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    room,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${devices.length} ${devices.length == 1 ? 'Device' : 'Devices'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDeviceTypeIcons(context, devices),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceTypeIcons(BuildContext context, List<Device> devices) {
    final deviceTypes = devices.map((d) => d.type).toSet().toList();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: deviceTypes.map((type) => _buildDeviceTypeIcon(type)).toList(),
    );
  }

  Widget _buildDeviceTypeIcon(DeviceType type) {
    IconData iconData;
    String label;

    switch (type) {
      case DeviceType.light:
        iconData = Icons.lightbulb_outline;
        label = 'Light';
      case DeviceType.fan:
        iconData = Icons.wind_power;
        label = 'Fan';
      case DeviceType.ac:
        iconData = Icons.ac_unit;
        label = 'AC';
      case DeviceType.bulb:
        iconData = Icons.lightbulb;
        label = 'Bulb';
      case DeviceType.purifier:
        iconData = Icons.air;
        label = 'Purifier';
      case DeviceType.climate:
        iconData = Icons.thermostat;
        label = 'Climate';
      case DeviceType.thermostat:
        iconData = Icons.thermostat_auto;
        label = 'Thermostat';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: Colors.white54,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showAddRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddRoomDialog(),
    );
  }
}

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
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
      title: const Text('Add New Room Device'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
              ),
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
              ),
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
        room: _nameController.text,
      );
      context.read<DeviceProvider>().addDevice(device);
      Navigator.pop(context);
    }
  }
}
