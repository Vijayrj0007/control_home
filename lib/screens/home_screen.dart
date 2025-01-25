import 'package:flutter/material.dart';
import '../screens/devices_screen.dart';
import '../screens/temperature_screen.dart';
import '../screens/rooms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RoomsScreen(),
    const DevicesScreen(),
    const TemperatureScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: Icon(Icons.thermostat),
            label: 'Temperature',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Rooms'),
            subtitle: const Text('Manage rooms and device locations'),
            onTap: () {
              // Navigate to room management
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Configure device alerts and reminders'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedules'),
            subtitle: const Text('Set up device automation schedules'),
            onTap: () {
              // Navigate to schedule settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            subtitle: const Text('Manage security settings and devices'),
            onTap: () {
              // Navigate to security settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('App information and help'),
            onTap: () {
              // Show about dialog
              showAboutDialog(
                context: context,
                applicationName: 'Smart Home Control',
                applicationVersion: '1.0.0',
                applicationLegalese: ' 2025 Your Company',
              );
            },
          ),
        ],
      ),
    );
  }
}
