import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'theme.dart';

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
          'Akses artikel seputar stroberi dan simpan riwayat hasil deteksi untuk memudahkan pemantauan dan pembelajaran.',
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
        duration: const Duration(milliseconds: 300),
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
            colors: [AppColors.primary, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PageView.builder(
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
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    page.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == i ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == i
                              ? AppColors.secondary
                              : AppColors.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _skipOnboarding,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 22,
                          ),
                        ),
                        child: Text(
                          _currentIndex == pages.length - 1 ? 'BEGIN' : 'NEXT',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
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
