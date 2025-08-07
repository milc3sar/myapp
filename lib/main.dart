import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supervisor/presentation/screens/home_screen.dart';
import 'package:supervisor/presentation/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive adapters here when models are created
  
  // Open Hive boxes
  await Hive.openBox('reports_box');
  await Hive.openBox('supplies_box');
  await Hive.openBox('evidences_box');
  await Hive.openBox('settings_box');
  
  runApp(const SupervisorApp());
}

class SupervisorApp extends StatelessWidget {
  const SupervisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supervisión',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
