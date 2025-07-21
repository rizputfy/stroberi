import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'theme.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.secondary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/artikel/1.png',
                width: 200,
                height: 100,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'StroMate v1.0.0',
                style: TextStyle(
                  fontSize: 26,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card: Deskripsi & Fitur
            CardSection(
              child: Column(
                children: const [
                  Text(
                    'StroMate adalah aplikasi cerdas yang membantu Anda mendeteksi tingkat kematangan buah stroberi (mentah, matang, busuk), memberikan tips penyimpanan terbaik, serta menyediakan informasi bermanfaat tentang stroberi.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fitur Aplikasi:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  FeatureItem(icon: LucideIcons.camera, text: 'Deteksi dari kamera/galeri'),
                  FeatureItem(icon: LucideIcons.history, text: 'Riwayat deteksi dengan pencarian'),
                  FeatureItem(icon: LucideIcons.bookOpen, text: 'Artikel informatif seputar stroberi'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card: Petunjuk Penggunaan
            CardSection(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Petunjuk Penggunaan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1. Buka menu "Deteksi" untuk memulai pengambilan gambar stroberi.\n'
                    '2. Pilih kamera atau galeri untuk mendeteksi tingkat kematangan.\n'
                    '3. Lihat hasil prediksi dan simpan jika diperlukan.\n'
                    '4. Akses riwayat deteksi melalui menu "Riwayat".\n'
                    '5. Baca tips penyimpanan dan artikel melalui menu yang tersedia.',
                    style: TextStyle(color: AppColors.primary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card: Developer
            CardSection(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/stroberi.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengembang:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rizki Putri Fitriyani',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        Text(
                          'rizputfy@gmail.com',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card: Lisensi
            CardSection(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lisensi:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Aplikasi ini dibuat untuk keperluan edukasi dan penelitian.',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable card container
class CardSection extends StatelessWidget {
  final Widget child;

  const CardSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

// Fitur item dengan ikon
class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
