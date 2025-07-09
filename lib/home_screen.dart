import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'deteksi.dart';
import 'history.dart';
import 'artikel_page.dart';
import 'tentang.dart';

class MenuItem {
  final String title;
  final String iconPath;

  const MenuItem({required this.title, required this.iconPath});
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<MenuItem> menuItems = const [
    MenuItem(title: 'CEK KEMATANGAN', iconPath: 'assets/icon/cek.png'),
    MenuItem(title: 'HISTORY', iconPath: 'assets/icon/history.png'),
    MenuItem(title: 'ARTIKEL STROBERI', iconPath: 'assets/icon/artikel.png'),
    MenuItem(title: 'TENTANG APLIKASI', iconPath: 'assets/icon/info.png'),
  ];

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Keluar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFDF2),
        body: Column(
          children: [
            Container(
              color: const Color(0xFFEF5A6F),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'HOME',
                        style: TextStyle(
                          color: Color(0xFFFCFDF2),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Logo diperbesar
            Image.asset(
              'assets/icon/logo.png',
              height: 140,
            ),

            // Grid menu diperluas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: GridView.builder(
                  itemCount: menuItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return GestureDetector(
                      onTap: () {
                        switch (item.title) {
                          case 'CEK KEMATANGAN':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DeteksiPage()));
                            break;
                          case 'HISTORY':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HistoryPage()));
                            break;
                          case 'ARTIKEL STROBERI':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ArtikelPage()));
                            break;
                          case 'TENTANG APLIKASI':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const TentangAplikasiPage()));
                            break;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5A6F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item.iconPath,
                              height: 60,
                              color: const Color(0xFFFCFDF2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
          ],
        ),
      ),
    );
  }
}
