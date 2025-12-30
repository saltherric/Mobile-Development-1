import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  final String id;
  final String name;
  final String description;
  final CategoryType type;

  Category({
    String? id,
    required this.name,
    required this.description,
    required this.type,
  }) : id = id ?? uuid.v4();

  /// Category → Map (for JSON storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name, // enum → String
    };
  }

  /// Map → Category (CRASH-PROOF)
  factory Category.fromMap(Map<String, dynamic> map) {
    final typeName = map['type'];

    final categoryType = CategoryType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => CategoryType.other,
    );

    return Category(
      id: map['id'] ?? uuid.v4(),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: categoryType,
    );
  }
}

enum CategoryType {
  saving('Saving', Icons.savings),
  investment('Investment', Icons.trending_up),
  debt('Debt', Icons.credit_card),
  avoidance('Avoidance', Icons.block),
  other('Other', Icons.category);

  final String label;
  final IconData icon;

  const CategoryType(this.label, this.icon);
}
