import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardData> pages = const [
    OnboardData(
      image: 'assets/icon/onboarding_1.png',
      title: 'Deteksi Kematangan Stroberi Secara Instan',
      description:
          'Ambil gambar stroberi dari kamera atau galeri, dan biarkan StroMate menentukan tingkat kematangannya secara otomatis!',
    ),
    OnboardData(
      image: 'assets/icon/onboarding_2.png',
      title: 'Pelajari & Telusuri Kembali',
      description:
          'Akses artikel seputar stroberi dan simpan riwayat deteksi untuk memudahkan pemantauan dan pembelajaran.',
    ),
    OnboardData(
      image: 'assets/icon/onboarding_3.png',
      title: 'Gunakan dengan Mudah, Hasilkan Keputusan Cepat',
      description:
          'StroMate hadir dengan antarmuka simpel dan hasil deteksi yang bisa kamu percaya—cocok untuk siapa saja, kapan saja!',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEF5A6F), Color(0xFFDD4562)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final page = pages[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(page.image, height: 300),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFCFDF2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFCFDF2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (i) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == i ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == i
                                  ? const Color(0xFFFCFDF2)
                                  : Color(0xFFFCFDF2).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFCFDF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            _currentIndex == pages.length - 1
                                ? 'BEGIN'
                                : 'NEXT',
                            style: const TextStyle(color: Color(0xFFEF5A6F)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color(0xFFFCFDF2),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardData {
  final String image;
  final String title;
  final String description;

  const OnboardData({
    required this.image,
    required this.title,
    required this.description,
  });
}
