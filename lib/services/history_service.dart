import '../models/history_item.dart';
import '../models/db_helper.dart';

class HistoryService {
  Future<void> saveDetection({
    required String imagePath,
    required String label,
    required double confidence,
  }) async {
    final item = HistoryItem(
      imagePath: imagePath,
      label: label,
      confidence: confidence,
      dateTime: DateTime.now().toIso8601String(),
    );

    await DBHelper().insertHistory(item);
  }

  Future<List<HistoryItem>> fetchHistory() async {
    return await DBHelper().getAllHistory();
  }
}
