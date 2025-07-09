import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StroMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Warna utama
        primaryColor: const Color(0xFFEF5A6F),
        scaffoldBackgroundColor: const Color(0xFFFCFDF2),

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEF5A6F),
          foregroundColor: Color(0xFFFCFDF2),
          elevation: 0,
        ),

        // Teks
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF5A827E)),
          bodyMedium: TextStyle(color: Color(0xFF5A827E)),
          titleMedium: TextStyle(color: Color(0xFF5A827E)),
        ),

        // Tombol
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF5A6F),
            foregroundColor: const Color(0xFFFCFDF2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),

        // Warna tambahan lainnya
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF5A6F),
          primary: const Color(0xFFEF5A6F),
          secondary: const Color(0xFF5A827E),
          onPrimary: const Color(0xFFFCFDF2),
          background: const Color(0xFFFCFDF2),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
