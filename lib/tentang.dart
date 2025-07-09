import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5A6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5A6F),
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Color(0xFFFCFDF2), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFCFDF2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            Text(
              'StroMate v1.0.0',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFFFCFDF2),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'StroMate adalah aplikasi cerdas yang membantu Anda mendeteksi tingkat kematangan buah stroberi (mentah, matang, busuk), memberikan tips penyimpanan terbaik, serta menyediakan informasi bermanfaat tentang stroberi.',
              style: TextStyle(color: Color(0xFFFCFDF2)),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              'Fitur Aplikasi:',
              style: TextStyle(
                color: Color(0xFFFCFDF2),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '• Deteksi kematangan dari kamera atau galeri\n'
              '• Riwayat deteksi dengan pencarian\n'
              '• Tips penyimpanan stroberi\n'
              '• Artikel informatif seputar stroberi',
              style: TextStyle(color: Color(0xFFFCFDF2)),
            ),
            SizedBox(height: 24),
            Text(
              'Developer: Nama Kamu\nEmail: emailkamu@example.com',
              style: TextStyle(color: Color(0xFFFCFDF2)),
            ),
            SizedBox(height: 16),
            Text(
              'Lisensi:\nAplikasi ini dibuat untuk keperluan edukasi dan penelitian.',
              style: TextStyle(color: Color(0xFFFCFDF2)),
            ),
          ],
        ),
      ),
    );
  }
}
