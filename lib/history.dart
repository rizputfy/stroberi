import 'dart:io';
import 'package:flutter/material.dart';
import 'services/history_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = HistoryService.history;

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Klasifikasi")),
      body: historyList.isEmpty
          ? const Center(child: Text("Belum ada riwayat."))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return Card(
                  child: ListTile(
                    leading: File(item.imagePath).existsSync()
                        ? Image.file(
                            File(item.imagePath),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(item.label),
                    subtitle: Text(
                      'Confidence: ${item.confidence}%\n${item.dateTime.toLocal()}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
