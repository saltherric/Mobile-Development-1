class DailyLog {
  final String id;
  final String habitId;        // Which habit was logged
  final DateTime date;         // When it happened
  final String? notes;         // Optional user notes
  final double? amount;        // Optional money amount (for savings)
  
  DailyLog({
    required this.id,
    required this.habitId,
    required this.date,
    this.notes,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'notes': notes,
      'amount': amount,
    };
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'],
      habitId: json['habitId'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      amount: json['amount']?.toDouble(),
    );
  }
}