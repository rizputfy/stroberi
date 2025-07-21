import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stroberi/theme.dart';

class HasilDeteksiPage extends StatelessWidget {
  final String imagePath;
  final String label;
  final double confidence;

  HasilDeteksiPage({
    super.key,
    required this.imagePath,
    required this.label,
    required this.confidence,
  });

  final Map<String, List<String>> ciriCiriBuah = {
    'Mentah': [
      'Berwarna hijau muda atau merah muda pucat.',
      'Permukaan kulit masih mengilap dan kaku.',
      'Tekstur keras saat ditekan.',
      'Belum mengeluarkan aroma khas stroberi.',
    ],
    'Matang': [
      'Warna merah cerah merata di seluruh permukaan.',
      'Permukaan kulit sedikit mengilap namun tidak kaku.',
      'Tekstur empuk ketika ditekan ringan.',
      'Mengeluarkan aroma manis khas stroberi.',
    ],
    'Busuk': [
      'Terdapat bercak hitam atau keunguan pada permukaan.',
      'Tekstur sangat lembek, bahkan berlendir.',
      'Mengeluarkan bau asam menyengat atau busuk.',
      'Muncul jamur putih atau abu-abu di permukaan.',
    ],
  };

  final Map<String, List<String>> tipsPenyimpanan = {
    'Mentah': [
      'Simpan di suhu ruang dalam wadah terbuka.',
      'Jauhkan dari sinar matahari langsung agar tidak cepat matang.',
      'Periksa secara berkala untuk melihat perubahan warna atau kematangan.',
    ],
    'Matang': [
      'Simpan dalam kulkas di wadah tertutup rapat.',
      'Lapisi dengan tisu kering untuk menyerap kelembaban.',
      'Konsumsi dalam 1–2 hari agar tetap segar.',
    ],
    'Busuk': [
      'Segera buang stroberi yang busuk.',
      'Pisahkan dari stroberi sehat untuk mencegah penyebaran jamur.',
      'Bersihkan wadah penyimpanan dengan air hangat dan sabun.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final ciriList = ciriCiriBuah[label] ?? ['Tidak tersedia'];
    final tipsList = tipsPenyimpanan[label] ?? ['Tidak tersedia'];

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            width: double.infinity,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: AppColors.secondary, size: 28),
                ),
                const SizedBox(width: 12),
                const Text(
                  'HASIL DETEKSI',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // Gambar Deteksi
                  Container(
                    height: 600,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: imagePath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(child: Text("Gambar tidak ditemukan")),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Nilai Akurasi : ${confidence.toStringAsFixed(0)} %",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "BUAH STROBERI ${label.toUpperCase()}",
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ciri-ciri dinamis
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CIRI-CIRI BUAH STROBERI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...ciriList.map((ciri) => Text('• $ciri', style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tips penyimpanan dinamis
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TIPS PENYIMPANAN BUAH STROBERI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...tipsList.map((tips) => Text('• $tips', style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
