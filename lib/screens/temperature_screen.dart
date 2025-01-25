import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';

class TemperatureScreen extends StatelessWidget {
  const TemperatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, deviceProvider, child) {
        // Get all temperature-related devices (AC, climate control, thermostat)
        final temperatureDevices = deviceProvider.getDevicesByType(DeviceType.ac) +
            deviceProvider.getDevicesByType(DeviceType.climate) +
            deviceProvider.getDevicesByType(DeviceType.thermostat);

        if (temperatureDevices.isEmpty) {
          return const Center(
            child: Text('No temperature control devices found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: temperatureDevices.length,
          itemBuilder: (context, index) {
            final device = temperatureDevices[index];
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
                        Switch(
                          value: device.isOn,
                          onChanged: (value) {
                            deviceProvider.toggleDevice(device.id, value);
                          },
                        ),
                      ],
                    ),
                    if (device.settings.temperature != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Temperature',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: device.isOn
                                    ? () {
                                        final newTemp = (device.settings.temperature ?? 24) - 1;
                                        deviceProvider.updateDeviceSettings(
                                          device.id,
                                          device.settings.copyWith(temperature: newTemp),
                                        );
                                      }
                                    : null,
                              ),
                              Text(
                                '${device.settings.temperature ?? 24}°C',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: device.isOn
                                    ? () {
                                        final newTemp = (device.settings.temperature ?? 24) + 1;
                                        deviceProvider.updateDeviceSettings(
                                          device.id,
                                          device.settings.copyWith(temperature: newTemp),
                                        );
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    if (device.settings.fanSpeed != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fan Speed',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: device.isOn
                                    ? () {
                                        final newSpeed = (device.settings.fanSpeed ?? 1) - 1;
                                        if (newSpeed >= 0) {
                                          deviceProvider.updateDeviceSettings(
                                            device.id,
                                            device.settings.copyWith(fanSpeed: newSpeed),
                                          );
                                        }
                                      }
                                    : null,
                              ),
                              Text(
                                '${device.settings.fanSpeed ?? 1}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: device.isOn
                                    ? () {
                                        final newSpeed = (device.settings.fanSpeed ?? 1) + 1;
                                        if (newSpeed <= 5) {
                                          deviceProvider.updateDeviceSettings(
                                            device.id,
                                            device.settings.copyWith(fanSpeed: newSpeed),
                                          );
                                        }
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
