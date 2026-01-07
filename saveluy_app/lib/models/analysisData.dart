class AnalysisData {
  final String id;
  final List<StreakItem> streaks;
  final List<CategoryItem> categories;

  AnalysisData({
    required this.id,
    required this.streaks,
    required this.categories,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // Streaks and categories are stored separately
    };
  }

  factory AnalysisData.fromMap(Map<String, dynamic> map) {
    return AnalysisData(
      id: map['id'],
      streaks: [],
      categories: [],
    );
  }
}

class StreakItem {
  final String id;
  final String analysisDataId; // Foreign key
  final String imagePath;
  final String title;
  final String subtitle;
  final int streakCount;
  final String category;

  StreakItem({
    required this.id,
    required this.analysisDataId,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.streakCount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'analysisDataId': analysisDataId,
      'imagePath': imagePath,
      'title': title,
      'subtitle': subtitle,
      'streakCount': streakCount,
      'category': category,
    };
  }

  factory StreakItem.fromMap(Map<String, dynamic> map) {
    return StreakItem(
      id: map['id'],
      analysisDataId: map['analysisDataId'],
      imagePath: map['imagePath'],
      title: map['title'],
      subtitle: map['subtitle'],
      streakCount: map['streakCount'],
      category: map['category'],
    );
  }
}

class CategoryItem {
  final String id;
  final String analysisDataId; // Foreign key
  final String imagePath;
  final String iconColorHex;
  final String label;
  final String status;
  final String statusColorHex;
  final int filledDots;
  final double progress;
  final String accentColorHex;

  CategoryItem({
    required this.id,
    required this.analysisDataId,
    required this.imagePath,
    required this.iconColorHex,
    required this.label,
    required this.status,
    required this.statusColorHex,
    required this.filledDots,
    required this.progress,
    required this.accentColorHex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'analysisDataId': analysisDataId,
      'imagePath': imagePath,
      'iconColorHex': iconColorHex,
      'label': label,
      'status': status,
      'statusColorHex': statusColorHex,
      'filledDots': filledDots,
      'progress': progress,
      'accentColorHex': accentColorHex,
    };
  }

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      id: map['id'],
      analysisDataId: map['analysisDataId'],
      imagePath: map['imagePath'],
      iconColorHex: map['iconColorHex'],
      label: map['label'],
      status: map['status'],
      statusColorHex: map['statusColorHex'],
      filledDots: map['filledDots'],
      progress: map['progress']?.toDouble() ?? 0.0,
      accentColorHex: map['accentColorHex'],
    );
  }
}
