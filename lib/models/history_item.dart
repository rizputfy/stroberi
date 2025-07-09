class HistoryItem {
  final int? id;
  final String imagePath;
  final String label;
  final double confidence;
  final String dateTime;

  HistoryItem({
    this.id,
    required this.imagePath,
    required this.label,
    required this.confidence,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'label': label,
      'confidence': confidence,
      'dateTime': dateTime,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'],
      imagePath: map['imagePath'],
      label: map['label'],
      confidence: map['confidence'],
      dateTime: map['dateTime'],
    );
  }
}
