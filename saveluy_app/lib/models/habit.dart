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

  static CategoryType fromName(String name) {
    return CategoryType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => CategoryType.other,
    );
  }
}

enum IconType {
  // Positive Habits
  piggyBank('Savings', Icons.savings_outlined),
  wallet('Wallet', Icons.account_balance_wallet_outlined),
  cash('Cash', Icons.payments_outlined),
  growth('Growth', Icons.trending_up_rounded),
  bank('Bank', Icons.account_balance_outlined),

  // Discipline / Avoidance
  block('Avoidance', Icons.block),
  noSpending('No Spend', Icons.money_off_csred_outlined),
  cutCard('Debt Cut', Icons.credit_card_off_outlined),
  shoppingCart('Shopping', Icons.shopping_cart_outlined),

  // General
  coffee('Coffee', Icons.coffee_outlined),
  gym('Health', Icons.fitness_center),
  home('Housing', Icons.home_outlined),
  other('Other', Icons.more_horiz);

  final String label;
  final IconData iconData;

  const IconType(this.label, this.iconData);

  static IconType fromName(String name) {
    return IconType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => IconType.other,
    );
  }
}

class Habit {
  final String id;
  final String name;
  final String quickLogText;
  final IconType icon;
  final bool showInQuickAdd;
  final CategoryType type;

  Habit({
    String? id,
    required this.name,
    required this.quickLogText,
    required this.icon,
    this.showInQuickAdd = true,
    required this.type,
  }) : id = id ?? uuid.v4();

  /// TO SQLITE
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quickLogText': quickLogText,
      'icon': icon.name,
      'showInQuickAdd': showInQuickAdd ? 1 : 0,
      'categoryType': type.name,
    };
  }

  /// FROM SQLITE
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      quickLogText: map['quickLogText'],
      icon: IconType.fromName(map['icon']),
      showInQuickAdd: map['showInQuickAdd'] == 1,
      type: CategoryType.fromName(map['categoryType']),
    );
  }
}