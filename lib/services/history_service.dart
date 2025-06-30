import '../models/history_item.dart';

class HistoryService {
  static final List<HistoryItem> _history = [];

  static void addHistory(HistoryItem item) {
    _history.insert(0, item);
  }

  static List<HistoryItem> get history => _history;
}
