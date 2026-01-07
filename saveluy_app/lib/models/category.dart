import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

/// Category model – groups related habits (e.g., Food, Transport).

enum CategoryIcon {
  food('Food', Icons.restaurant),
  savings('Savings', Icons.savings),
  shopping('Shopping', Icons.shopping_cart),
  health('Health', Icons.fitness_center),
  transport('Transport', Icons.directions_car),
  entertainment('Entertainment', Icons.movie),
  utilities('Utilities', Icons.home),
  other('Other', Icons.category);

  final String label;
  final IconData icon;

  const CategoryIcon(this.label, this.icon);

  /// Parse enum from its string name.
  static CategoryIcon fromName(String? name) {
    if (name == null) return CategoryIcon.other;
    return CategoryIcon.values.firstWhere(
      (e) => e.name == name,
      orElse: () => CategoryIcon.other,
    );
  }
}

class Category {
  final String id;
  final String name;
  final CategoryIcon icon;
  final String colorHex; // Store as hex string (e.g., "#FF20C997")

  Category({
    String? id,
    required this.name,
    this.icon = CategoryIcon.other,
    this.colorHex = '#FF20C997', // Default green
  }) : id = id ?? uuid.v4();

  /// Serialize to Map for storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.name,
      'colorHex': colorHex,
    };
  }

  /// Deserialize from Map read from storage.
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: CategoryIcon.fromName(map['icon']),
      colorHex: (map['colorHex'] != null && map['colorHex'].toString().isNotEmpty) 
          ? map['colorHex'] 
          : '#FF20C997',
    );
  }

  /// Copy with optional field overrides.
  Category copyWith({
    String? id,
    String? name,
    CategoryIcon? icon,
    String? colorHex,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  /// Color derived from `colorHex`.
  Color get color {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0x')));
    } catch (e) {
      return const Color(0xFF20C997); // Default green if parsing fails
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
