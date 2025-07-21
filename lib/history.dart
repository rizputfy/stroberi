import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stroberi/theme.dart';
import 'models/history_item.dart';
import 'services/history_service.dart';
import 'hasil_deteksi_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> historyList = [];
  List<HistoryItem> filteredList = [];
  DateTime? selectedDate;
  
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

  void _applyFilters() {
    final queryDate = selectedDate?.toIso8601String().substring(0, 10);
    setState(() {
      filteredList = historyList.where((item) {
        final matchDate = queryDate == null || item.dateTime.startsWith(queryDate);
        return matchDate;
      }).toList();
    });
  }

  void _filterByDate(DateTime date) {
    selectedDate = date;
    _applyFilters();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) _filterByDate(picked);
  }

void _showHistoryDetails(BuildContext context, HistoryItem item) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Detail",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (_, anim, __, ___) {
      return Transform.translate(
        offset: Offset(0, 50 * (1 - anim.value)),
        child: Opacity(
          opacity: anim.value,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tanggal
                      Text(
                        item.dateTime.substring(0, 10),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Gambar deteksi
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: File(item.imagePath).existsSync()
                            ? Image.file(
                                File(item.imagePath),
                                height: 270,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Label kelas
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Akurasi
                      Text(
                        "Akurasi: ${item.confidence.toStringAsFixed(2)}%",
                        style: const TextStyle(fontSize: 20, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Tombol aksi
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HasilDeteksiPage(
                                  imagePath: item.imagePath,
                                  label: item.label,
                                  confidence: item.confidence,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Lihat Hasil Deteksi",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol close
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  void _confirmDeleteItem(HistoryItem item) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Konfirmasi Hapus"),
      content: const Text("Yakin ingin menghapus riwayat ini?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
      ],
    ),
  );

  if (confirmed ?? false) {
  await HistoryService().deleteHistoryById(item.id!);
  await loadHistory();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Riwayat berhasil dihapus.'),
      duration: Duration(seconds: 2),
    ),
  );
}

}

void _confirmDeleteAll() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Konfirmasi Hapus Semua"),
      content: const Text("Yakin ingin menghapus semua riwayat?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus Semua")),
      ],
    ),
  );

  if (confirmed ?? false) {
  await HistoryService().deleteAllHistory();
  await loadHistory();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Semua riwayat berhasil dihapus.'),
      duration: Duration(seconds: 2),
    ),
  );
}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            width: double.infinity,
            color: Colors.pinkAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "RIWAYAT DETEKSI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                  onPressed: filteredList.isNotEmpty ? _confirmDeleteAll : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Pilih Tanggal"),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            selectedDate == null
                                ? 'mm/dd/yyyy'
                                : '${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.year}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text("Belum ada riwayat."))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return GestureDetector(
                      onTap: () => _showHistoryDetails(context, item),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.pinkAccent.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: File(item.imagePath).existsSync()
                                    ? Image.file(File(item.imagePath), width: 56, height: 56, fit: BoxFit.cover)
                                    : const Icon(Icons.image, size: 56),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.dateTime.substring(0, 10),
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.label,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _confirmDeleteItem(item),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
