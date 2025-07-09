import 'package:flutter/material.dart';
import 'detail_deteksi_page.dart';
import 'dart:io';

class HasilDeteksiPage extends StatelessWidget {
  final String imagePath;
  final String label;
  final double confidence;

  const HasilDeteksiPage({
    super.key,
    required this.imagePath,
    required this.label,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5A6F),
        title: const Text("HASIL DETEKSI", style: TextStyle(color: Color(0xFFFCFDF2))),
        iconTheme: const IconThemeData(color: Color(0xFFFCFDF2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(File(imagePath), height: 300),
            const SizedBox(height: 20),
            Text(
              "BUAH STROBERI ${label.toUpperCase()}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text("Nilai Akurasi: ${confidence.toStringAsFixed(0)}%",
                style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailDeteksiPage(label: label),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5A6F),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text("LIHAT DETAIL", style: TextStyle(color: Color(0xFFFCFDF2))),
            ),
          ],
        ),
      ),
    );
  }
}
