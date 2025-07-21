import 'package:flutter/material.dart';
import 'detail_artikel.dart';
import 'theme.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({super.key});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  final List<Map<String, String>> artikelList = [
    {
      'title': 'Mengenal Buah Stroberi: Kandungan Gizi dan Manfaatnya',
      'category': 'Umum',
      'date': 'Juli 13, 2025',
      'time': '3 min read',
      'image': 'assets/images/stroberi1.jpg',
       'content': '''
    Stroberi (Fragaria × ananassa) adalah buah kecil berwarna merah cerah yang sangat digemari. Di balik ukurannya yang mungil, stroberi menyimpan berbagai manfaat luar biasa.

    Kandungan Gizi Stroberi per 100 gram:
    - Kalori: ±32 kkal
    - Vitamin C: 59 mg (98% AKG)
    - Serat: 2 g
    - Antioksidan: tinggi (anthocyanin, ellagic acid)

    Manfaat Stroberi:
    - Meningkatkan imunitas
    - Menurunkan risiko penyakit jantung
    - Menjaga kesehatan kulit
    - Membantu kontrol gula darah
    '''
    },
    {
      'title': 'Tanda-Tanda Kematangan Stroberi: Mentah, Matang, atau Busuk?',
      'category': 'Edukasi',
      'date': 'Juli 13, 2025',
      'time': '3 min read',
      'image': 'assets/images/tangan.jpg',
       'content': '''
    ✔ Stroberi Mentah:
    - Warna: Hijau hingga putih kemerahan
    - Tekstur: Keras saat ditekan
    - Aroma: Hampir tidak ada
    - Rasa: Asam dan belum manis

    ✔ Stroberi Matang:
    - Warna: Merah cerah merata
    - Tekstur: Lembut tapi tidak lembek
    - Aroma: Manis khas stroberi
    - Rasa: Manis dan segar

    ✔ Stroberi Busuk:
    - Warna: Coklat kehitaman atau berbintik putih (jamur)
    - Tekstur: Lembek, berair
    - Aroma: Asam atau tidak sedap
    - Rasa: Tidak layak konsumsi
    '''
    },
    {
      'title': 'Tips Menyimpan Stroberi Matang agar Tidak Cepat Busuk',
      'category': 'Tips',
      'date': 'Juli 13, 2025',
      'time': '2 min read',
      'image': 'assets/images/stroberi.jpg',
       'content': '''
    - Simpan stroberi matang di lemari es dalam wadah terbuka berlapis tisu.
    - Jangan dicuci terlebih dahulu, cuci hanya saat akan dikonsumsi.
    - Hindari menyimpan bersama buah yang cepat membusuk lainnya.
    - Bisa tahan 3–5 hari dalam suhu dingin.
    '''
    },
    {
      'title': 'Cara Menyimpan Stroberi Mentah Hingga Siap Dikonsumsi',
      'category': 'Tips',
      'date': 'Juli 13, 2025',
      'time': '2 min read',
      'image': 'assets/images/stroberi1.jpg',
      'content': '''
    - Simpan stroberi mentah dalam suhu ruang bersuhu sejuk.
    - Gunakan kantong kertas agar tidak terlalu lembap.
    - Bila ingin mempercepat kematangan, letakkan dekat buah pisang atau apel.
    '''
    },
    {
      'title': 'Haruskah Stroberi Busuk Dibuang Semua?',
      'category': 'Tips',
      'date': 'Juli 13, 2025',
      'time': '2 min read',
      'image': 'assets/images/tangan.jpg',
      'content': '''
    - Jangan konsumsi stroberi yang sudah menunjukkan jamur atau tekstur lembek.
    - Segera pisahkan stroberi busuk agar tidak menyebar ke buah lain.
    - Jika hanya bagian ujung yang rusak, bisa dipotong jika belum menjamur.
    '''
    },
    {
      'title': 'Cara Mengolah Stroberi Matang: Segar dan Lezat!',
      'category': 'Resep',
      'date': 'Juli 13, 2025',
      'time': '3 min read',
      'image': 'assets/images/piring.jpg',
       'content': '''
    - Jus Stroberi: Blender stroberi matang dengan madu dan es.
    - Selai Stroberi: Masak dengan gula dan sedikit lemon.
    - Salad Buah: Padukan dengan yoghurt, pisang, dan apel.
    - Smoothie Bowl: Stroberi beku, pisang, dan granola sehat.
    '''
    },
    {
      'title': 'Penyebaran Stroberi di Semarang dan Sekitarnya',
      'category': 'Lokal',
      'date': 'Juli 13, 2025',
      'time': '2 min read',
      'image': 'assets/images/kebun.jpg',
       'content': '''
    - Stroberi banyak dibudidayakan di daerah dataran tinggi sekitar Semarang.
    - Lokasi terkenal: Bandungan (Kab. Semarang), Kopeng (Salatiga), dan Ungaran.
    - Beberapa lokasi agrowisata menyediakan petik stroberi langsung dari kebun.
    '''
    },
  ];

  final List<String> categories = ['Semua', 'Umum', 'Edukasi', 'Tips', 'Resep', 'Lokal'];
  String selectedCategory = 'Semua';

  List<Map<String, String>> get filteredArtikel {
    if (selectedCategory == 'Semua') return artikelList;
    return artikelList.where((a) => a['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'ARTIKEL STROBERI',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer untuk seimbangkan ikon back
              ],
            ),

              // Dropdown Filter
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Artikel ListView
              Expanded(
                child: ListView.builder(
                  itemCount: filteredArtikel.length,
                  itemBuilder: (context, index) {
                    final artikel = filteredArtikel[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailArtikelPage(
                              title: artikel['title']!,
                              content: artikel['content']!,
                              imagePath: artikel['image']!,
                              date: artikel['date']!,
                              time: artikel['time']!,
                              category: artikel['category']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: AssetImage(artikel['image']!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  artikel['category']!,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artikel['title']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, color: Colors.white70, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        artikel['time']!,
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
