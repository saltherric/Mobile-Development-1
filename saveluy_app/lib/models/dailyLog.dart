import 'package:uuid/uuid.dart';

const uuid = Uuid();

/// Daily log model – records a habit completion on a date.
class DailyLog {
  final String id;
  final String habitId;   // Links to which habit was completed
  final DateTime date;    // When it was completed
  final String? notes;    // Optional notes
  final double? amount;   // Optional amount (for financial habits like savings)

  DailyLog({
    String? id,
    required this.habitId,
    required this.date,
    this.notes,
    this.amount,
  }) : id = id ?? uuid.v4();

  /// Serialize to Map for storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),  // Store as text in ISO format
      'notes': notes,
      'amount': amount,
    };
  }

  /// Deserialize from Map read from storage.
  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      id: map['id'],
      habitId: map['habitId'],
      date: DateTime.parse(map['date']),  // Convert ISO string back to DateTime
      notes: map['notes'],
      amount: map['amount']?.toDouble(),
    );
  }
}