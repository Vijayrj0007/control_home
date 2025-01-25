import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/device_provider.dart';
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  final storageService = LocalStorageService();
  await storageService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final LocalStorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeviceProvider(storageService),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Home Control',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1A1D1F),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF246BFD),
            secondary: Color(0xFFFF9800),
            surface: Color(0xFF2C2F33),
            onSurface: Colors.white,
            error: Color(0xFFCF6679),
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF2C2F33),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
