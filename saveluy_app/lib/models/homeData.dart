class HomeData {
  final String id;
  final double overallScore; // 0-100
  final String overallMessage;
  final List<CategoryActivityData> categoryActivities;

  HomeData({
    required this.id,
    required this.overallScore,
    required this.overallMessage,
    required this.categoryActivities,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'overallScore': overallScore,
      'overallMessage': overallMessage,
      // Note: categoryActivities are stored separately
    };
  }

  // Create from SQLite Map
  factory HomeData.fromMap(Map<String, dynamic> map) {
    return HomeData(
      id: map['id'],
      overallScore: map['overallScore']?.toDouble() ?? 0.0,
      overallMessage: map['overallMessage'] ?? '',
      categoryActivities: [], // Will be populated separately
    );
  }
}

class CategoryActivityData {
  final String id;
  final String homeDataId; // Foreign key
  final String imagePath;
  final String label;
  final String status;
  final int filledDots; // 0-5
  final double progress; // 0-1
  final String accentColorHex; // Store color as hex string

  CategoryActivityData({
    required this.id,
    required this.homeDataId,
    required this.imagePath,
    required this.label,
    required this.status,
    required this.filledDots,
    required this.progress,
    required this.accentColorHex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'homeDataId': homeDataId,
      'imagePath': imagePath,
      'label': label,
      'status': status,
      'filledDots': filledDots,
      'progress': progress,
      'accentColorHex': accentColorHex,
    };
  }

  factory CategoryActivityData.fromMap(Map<String, dynamic> map) {
    return CategoryActivityData(
      id: map['id'],
      homeDataId: map['homeDataId'],
      imagePath: map['imagePath'],
      label: map['label'],
      status: map['status'],
      filledDots: map['filledDots'],
      progress: map['progress']?.toDouble() ?? 0.0,
      accentColorHex: map['accentColorHex'],
    );
  }
}
