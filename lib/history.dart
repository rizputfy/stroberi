import 'dart:io';
import 'package:flutter/material.dart';
import 'models/history_item.dart';
import 'services/history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> historyList = [];
  List<HistoryItem> filteredList = [];
  DateTime? selectedDate;

  final Map<String, String> tipsPenyimpanan = {
    'Mentah': 'Simpan di suhu ruang dan hindari paparan sinar matahari langsung.',
    'Matang': 'Segera konsumsi atau simpan di lemari es untuk mempertahankan kesegaran.',
    'Busuk': 'Buang stroberi yang sudah busuk agar tidak mencemari stroberi lainnya.',
  };

  final Map<String, String> ciriCiriBuah = {
    'Mentah': 'Buah berwarna hijau pucat atau merah muda, tekstur keras.',
    'Matang': 'Berwarna merah cerah merata, tekstur lembut namun tidak lembek.',
    'Busuk': 'Terlihat lembek, mengeluarkan bau asam atau muncul jamur putih.',
  };

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await HistoryService().fetchHistory();
    setState(() {
      historyList = data;
      filteredList = data;
    });
  }

  void _showHistoryDetails(BuildContext context, HistoryItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Buah Stroberi ${item.label}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Akurasi: ${item.confidence.toStringAsFixed(2)}%"),
            const SizedBox(height: 8),
            Text("Tanggal: ${item.dateTime.substring(0, 10)}"),
            const SizedBox(height: 12),
            if (ciriCiriBuah.containsKey(item.label))
              Text("Ciri-ciri: ${ciriCiriBuah[item.label]}", style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            if (tipsPenyimpanan.containsKey(item.label))
              Text("Tips penyimpanan: ${tipsPenyimpanan[item.label]}", style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  void _filterByDate(DateTime date) {
    final queryDate = date.toIso8601String().substring(0, 10);
    setState(() {
      selectedDate = date;
      filteredList = historyList.where((item) => item.dateTime.startsWith(queryDate)).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _filterByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Klasifikasi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          )
        ],
      ),
      body: filteredList.isEmpty
          ? const Center(child: Text("Belum ada riwayat."))
          : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return GestureDetector(
                  onTap: () => _showHistoryDetails(context, item),
                  child: Card(
                    color: Colors.pinkAccent,
                    child: ListTile(
                      leading: File(item.imagePath).existsSync()
                          ? Image.file(File(item.imagePath), width: 56, height: 56, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Text("Buah Stroberi ${item.label}"),
                      subtitle: Text(item.dateTime.substring(0, 10)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
