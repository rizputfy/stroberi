import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({Key? key}) : super(key: key);

  void _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka aplikasi email.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

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
                'assets/artikel/logo.png',
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

            const CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apa yang Kami Tawarkan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'StroMate menghadirkan kemudahan bagi Anda untuk mengetahui tingkat kematangan buah stroberi hanya dengan mengunggah gambar. Dengan kecerdasan buatan, aplikasi ini memberikan informasi tingkat kematangan buah stroberi secara cepat dan edukatif untuk dapat membantu petani, pedagang, maupun konsumen sehari-hari. Aplikasi Stromate dibangun dengan menggunakan teknologi terkini yakni Convolutional Neural Network (CNN) dengan arsitektur MobileNetV2, bagian dari algoritma Deep Learning.',
                    style: TextStyle(color: AppColors.primary, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitur Utama:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  FeatureItem(icon: Icons.camera_alt, text: 'Deteksi Tingkat Kematangan Buah Stroberi dari gambar unggahan kamera atau galeri pengguna'),
                  FeatureItem(icon: Icons.history, text: 'Riwayat deteksi dengan filter berdasarkan tanggal'),
                  FeatureItem(icon: Icons.menu_book, text: 'Artikel informatif seputar buah stroberi'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manfaat Aplikasi:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Membantu mengetahui tingkat kematangan stroberi dari gambar secara cepat\n'
                    '• Memberikan tips penyimpanan berdasarkan kondisi buah setelah dideteksi\n'
                    '• Menyediakan informasi dan edukasi tentang buah stroberi melalui fitur artikel\n',
                    style: TextStyle(color: AppColors.primary, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const CardSection(
              child: Column(
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

            CardSection(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/icon/pengembang.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pengembang:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Rizki Putri Fitriyani',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        GestureDetector(
                          onTap: () => _launchEmail(context, 'rizputfy@gmail.com'),
                          child: const Text(
                            'rizputfy@gmail.com',
                            style: TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const CardSection(
              child: Column(
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
