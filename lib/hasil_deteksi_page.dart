import 'dart:io';
import 'package:flutter/material.dart';
import '/theme.dart';

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
    'Bukan Stroberi': [
      'Gambar yang dimasukkan bukan buah stroberi.',
      'Tidak memiliki ciri khas warna atau bentuk stroberi.',
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
    'Bukan Stroberi': [
      'Coba unggah ulang gambar dengan objek buah stroberi.',
      'Pastikan gambar tidak blur dan menampilkan buah secara jelas.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Normalisasi label
    String normalizedLabel = label.trim().toLowerCase();

    if (normalizedLabel == 'mentah') {
      normalizedLabel = 'Mentah';
    } else if (normalizedLabel == 'matang') {
      normalizedLabel = 'Matang';
    } else if (normalizedLabel == 'busuk') {
      normalizedLabel = 'Busuk';
    } else if (normalizedLabel == 'bukanstroberi') {
      normalizedLabel = 'Bukan Stroberi';
    }

    final ciriList = ciriCiriBuah[normalizedLabel] ?? ['Informasi tidak tersedia'];
    final tipsList = tipsPenyimpanan[normalizedLabel] ?? ['Informasi tidak tersedia'];

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
                  child: const Icon(Icons.arrow_back, color: AppColors.secondary, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'HASIL DETEKSI',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 26,
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
                      "BUAH STROBERI ${normalizedLabel.toUpperCase()}",
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 28,
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
                        Text(
                          'CIRI-CIRI BUAH STROBERI ${normalizedLabel.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...ciriList.map((ciri) => Text(
                              '• $ciri',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            )).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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
                        Text(
                          'TIPS PENYIMPANAN BUAH STROBERI ${normalizedLabel.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...tipsList.map((tips) => Text(
                              '• $tips',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            )).toList(),
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
