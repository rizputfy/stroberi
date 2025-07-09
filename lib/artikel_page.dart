import 'package:flutter/material.dart';

class ArtikelPage extends StatelessWidget {
  ArtikelPage({Key? key}) : super(key: key);

  final List<Map<String, String>> artikelList = [
    {
      'title': 'Mengenal Buah Stroberi',
      'excerpt': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."',
      'image': 'assets/images/strawberry1.png',
      'content': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ...'
    },
    {
      'title': 'Tips Menyimpan Buah Stroberi',
      'excerpt': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."',
      'image': 'assets/images/strawberry2.png',
      'content': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ...'
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5A6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5A6F),
        title: const Text(
          'ARTIKEL',
          style: TextStyle(color: Color(0xFFFCFDF2), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFCFDF2)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: artikelList.length,
        itemBuilder: (context, index) {
          final artikel = artikelList[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailArtikelPage(
                  title: artikel['title']!,
                  content: artikel['content']!,
                  imagePath: artikel['image']!,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image, size: 48, color: Colors.black87),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artikel['title']!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          artikel['excerpt']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Baca Selengkapnya',
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.black54),
                          ),
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
    );
  }
}

class DetailArtikelPage extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;

  const DetailArtikelPage({
    super.key,
    required this.title,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5A6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5A6F),
        title: const Text(
          'ARTIKEL',
          style: TextStyle(color: Color(0xFFFCFDF2), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFCFDF2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 120, color: Colors.black87),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFFFCFDF2), fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(color: Color(0xFFFCFDF2)),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
