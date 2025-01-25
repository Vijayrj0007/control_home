// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:control_home/main.dart';
import 'package:control_home/services/local_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    
    // Create and initialize storage service
    final storageService = LocalStorageService();
    await storageService.init();
    
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(storageService: storageService));
    
    // Verify that the app builds successfully
    expect(find.byType(MyApp), findsOneWidget);
  });
}
