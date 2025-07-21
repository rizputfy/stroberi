import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/history_item.dart';
import '../models/db_helper.dart';

class HistoryService {
  Future<void> saveDetection({
    required String imagePath,
    required String label,
    required double confidence,
  }) async {
    final savedImagePath = await _saveImageToPermanentStorage(imagePath);

    final item = HistoryItem(
      imagePath: savedImagePath,
      label: label,
      confidence: confidence,
      dateTime: DateTime.now().toIso8601String(),
    );

    await DBHelper().insertHistory(item);
  }

  Future<String> _saveImageToPermanentStorage(String originalPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'stroberi_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newPath = p.join(dir.path, filename);

    final imageFile = File(originalPath);
    if (await imageFile.exists()) {
      await imageFile.copy(newPath);
    }

    return newPath;
  }

  Future<List<HistoryItem>> fetchHistory() async {
    return await DBHelper().getAllHistory();
  }

  Future<void> deleteHistoryById(int id) async {
    await DBHelper().deleteHistoryById(id);
  }

  Future<void> deleteAllHistory() async {
    await DBHelper().deleteAllHistory();
  }
}
