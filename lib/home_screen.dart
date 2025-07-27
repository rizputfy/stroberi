import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'deteksi.dart';
import 'history.dart';
import 'artikel_page.dart';
import 'tentang.dart';
import 'theme.dart';

class MenuItem {
  final String title;
  final String iconPath;

  const MenuItem({required this.title, required this.iconPath});
}

// (Import dan class MenuItem tetap sama)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<MenuItem> menuItems = const [
    MenuItem(title: 'CEK KEMATANGAN', iconPath: 'assets/icon/cek.png'),
    MenuItem(title: 'HISTORY', iconPath: 'assets/icon/history.png'),
    MenuItem(title: 'ARTIKEL STROBERI', iconPath: 'assets/icon/artikel.png'),
    MenuItem(title: 'TENTANG APLIKASI', iconPath: 'assets/icon/info.png'),
  ];

  final List<Map<String, dynamic>> artikelPopuler = [
    {
      'image': 'assets/artikel/logo.png',
      'title': 'STROMATE APP',
      'page': null,
    },
    {
      'image': 'assets/artikel/4.png',
      'title': 'Deteksi Stroberi',
      'page': const DeteksiPage(),
    },
    {
      'image': 'assets/artikel/2.png',
      'title': 'Riwayat Deteksi',
      'page': const HistoryPage(),
    },
    {
      'image': 'assets/artikel/3.png',
      'title': 'Artikel Stroberi',
      'page': const ArtikelPage(),
    },
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(now);
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
              TextButton(onPressed: () => SystemNavigator.pop(), child: const Text('Keluar')),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final int newPage = _pageController.page!.round();
      if (_currentPage != newPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                height: 450,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getCurrentDate(),
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      getGreeting(),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Yuk, cek kematangan stroberi kamu hari ini!',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    // ARTIKEL GESER DENGAN PAGEVIEW
                    SizedBox(
                      height: 240,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: artikelPopuler.length,
                        itemBuilder: (context, index) {
                          final artikel = artikelPopuler[index];
                          return GestureDetector(
                            onTap: () {
                              if (artikel['page'] != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => artikel['page']),
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(artikel['image']),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Text(
                                  artikel['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // TITIK INDIKATOR
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(artikelPopuler.length, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 12 : 8,
                          height: isActive ? 12 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MENU GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    itemCount: menuItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return GestureDetector(
                        onTap: () {
                          switch (item.title) {
                            case 'CEK KEMATANGAN':
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const DeteksiPage()));
                              break;
                            case 'HISTORY':
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
                              break;
                            case 'ARTIKEL STROBERI':
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ArtikelPage()));
                              break;
                            case 'TENTANG APLIKASI':
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const TentangAplikasiPage()));
                              break;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFEF5A6F),
                                ),
                                child: Image.asset(
                                  item.iconPath,
                                  height: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEF5A6F),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // TOMBOL DETEKSI BAWAH
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DeteksiPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5A6F),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'DETEKSI SEKARANG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
