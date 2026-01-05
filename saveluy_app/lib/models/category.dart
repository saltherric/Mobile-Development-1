import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'], 
      name: json['name'],
      description: json['description'],
      type: CategoryType.values.byName(json['type']), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name, 
    };
  }
}