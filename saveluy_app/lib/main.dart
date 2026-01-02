import 'package:flutter/material.dart';
import 'ui/screens/categories/category_screen.dart';

void main() {
  runApp(const SaveLuyApp());
}

class SaveLuyApp extends StatelessWidget {
  const SaveLuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaveLuy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF81C784),
          primary: const Color(0xFF81C784),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      // Starting with the Setup/Settings screen to test Category creation
      home: const SettingsScreen(),
    );
  }
}
