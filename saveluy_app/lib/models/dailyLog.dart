import 'package:uuid/uuid.dart';

// Initialize the UUID generator
const _uuid = Uuid();

class DailyLog {
  final String id;
  final String habitId;   // Foreign Key linking to the Habit
  final DateTime date;    // The timestamp of the log
  final String? notes;    // Optional notes from the user
  final double? amount;   // Optional numerical value (e.g., amount saved)

  DailyLog({
    String? id,
    required this.habitId,
    required this.date,
    this.notes,
    this.amount,
  }) : id = id ?? _uuid.v4(); // Generate a new ID if one isn't provided

  /// Convert a DailyLog object into a Map to store in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(), // Store DateTime as an ISO String
      'notes': notes,
      'amount': amount,
    };
  }

  /// Create a DailyLog object from a Map (retrieved from SQLite)
  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      id: map['id'] as String,
      habitId: map['habitId'] as String,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
    );
  }
}