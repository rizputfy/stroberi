class HistoryItem {
  final String label;
  final String confidence;
  final DateTime dateTime;
  final String imagePath; // Tambahan baru

  HistoryItem({
    required this.label,
    required this.confidence,
    required this.dateTime,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'dateTime': dateTime.toIso8601String(),
      'imagePath': imagePath, // simpan juga path gambar
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      label: map['label'],
      confidence: map['confidence'],
      dateTime: DateTime.parse(map['dateTime']),
      imagePath: map['imagePath'],
    );
  }
}
