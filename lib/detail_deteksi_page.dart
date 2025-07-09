import 'package:flutter/material.dart';

class DetailDeteksiPage extends StatelessWidget {
  final String label;

  const DetailDeteksiPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> ciriCiriBuah = {
      'Mentah': 'Buah berwarna hijau pucat atau merah muda, tekstur keras.',
      'Matang': 'Berwarna merah cerah merata, tekstur lembut namun tidak lembek.',
      'Busuk': 'Terlihat lembek, mengeluarkan bau asam atau muncul jamur putih.',
    };

    final Map<String, String> tipsPenyimpanan = {
      'Mentah': 'Simpan di suhu ruang dan hindari paparan sinar matahari langsung.',
      'Matang': 'Segera konsumsi atau simpan di lemari es untuk mempertahankan kesegaran.',
      'Busuk': 'Buang stroberi yang sudah busuk agar tidak mencemari stroberi lainnya.',
    };

    final labelUpper = label.toUpperCase();

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
            _buildBox(
              title: "CIRI-CIRI BUAH STROBERI $labelUpper",
              content: ciriCiriBuah[label] ?? "-",
            ),
            const SizedBox(height: 16),
            _buildBox(
              title: "TIPS MENYIMPAN BUAH STROBERI",
              content: tipsPenyimpanan[label] ?? "-",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEF5A6F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFFFCFDF2),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Color(0xFFFCFDF2))),
        ],
      ),
    );
  }
}
