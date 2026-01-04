class Habit {
  final String id;
  final String name;           // e.g., "Coffee Avoided"
  final String quickLogText;   // e.g., "No Coffee Today"
  final String icon;           // Icon name or emoji
  final String category;       // Which category it belongs to
  final String habitType;      // "spending_avoid", "saving", "positive_action"
  final bool showInQuickAdd;   // Show on Add Record screen?
  
  Habit({
    required this.id,
    required this.name,
    required this.quickLogText,
    required this.icon,
    required this.category,
    required this.habitType,
    this.showInQuickAdd = true,
  });

  // Convert to JSON (for saving to file)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quickLogText': quickLogText,
      'icon': icon,
      'category': category,
      'habitType': habitType,
      'showInQuickAdd': showInQuickAdd,
    };
  }

  // Create from JSON (when loading from file)
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      quickLogText: json['quickLogText'],
      icon: json['icon'],
      category: json['category'],
      habitType: json['habitType'],
      showInQuickAdd: json['showInQuickAdd'] ?? true,
    );
  }
}