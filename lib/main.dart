import 'package:flutter/material.dart';
import 'deteksi.dart';
import 'history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klasifikasi Stroberi',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Utama')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Deteksi Stroberi"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DeteksiPage()));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text("Riwayat Deteksi"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HistoryPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
