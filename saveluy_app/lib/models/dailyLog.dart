import 'package:uuid/uuid.dart';

const uuid = Uuid();

class DailyLog {
  final String id;
  final String habitId;   // Link to the Habit being logged
  final DateTime date;    // The date/time the habit was performed
  final String? notes;    // Optional notes
  final double? amount;   // For financial habits (e.g., "Saved RM5")

  DailyLog({
    String? id,
    required this.habitId,
    required this.date,
    this.notes,
    this.amount,
  }) : id = id ?? uuid.v4();

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      // Store only the date part (YYYY-MM-DD) if you only care about daily logs
      'date': date.toIso8601String(), 
      'notes': notes,
      'amount': amount,
    };
  }

  // Create from SQLite Map
  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      id: map['id'],
      habitId: map['habitId'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      amount: map['amount']?.toDouble(),
    );
  }
}