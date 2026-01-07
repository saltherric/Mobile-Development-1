import '../../models/dailyLog.dart';
import '../../utils/databaseHelper.dart';

/// DailyLogRepository - Access daily logs using the existing DatabaseHelper.
class DailyLogRepository {
  final DatabaseHelper _db = DatabaseHelper();

  /// Get all daily logs
  Future<List<DailyLog>> getAllLogs() async {
    final logMaps = await _db.getAllDailyLogs();
    return logMaps.map((m) => DailyLog.fromMap(m)).toList();
  }

  /// Get all logs for a specific habit
  Future<List<DailyLog>> getLogsForHabit(String habitId) async {
    final logMaps = await _db.getDailyLogs(habitId);
    return logMaps.map((m) => DailyLog.fromMap(m)).toList();
  }

  /// Get logs for today
  Future<List<DailyLog>> getLogsForToday() async {
    return getLogsForDate(DateTime.now());
  }

  /// Get logs for a specific date
  Future<List<DailyLog>> getLogsForDate(DateTime date) async {
    final logMaps = await _db.getDailyLogsForDate(date);
    return logMaps.map((m) => DailyLog.fromMap(m)).toList();
  }

  /// Save a daily log (when user completes a habit)
  Future<void> saveLog(DailyLog log) async {
    await _db.insertDailyLog(log.toMap());
  }

  /// Delete a specific log
  Future<void> deleteLog(String logId) async {
    await _db.deleteDailyLog(logId);
  }

  /// Count of today's logs
  Future<int> getTodayLogsCount() async {
    final logs = await getLogsForToday();
    return logs.length;
  }

  /// Total amount saved today (sum of non-null amounts)
  Future<double> getTodaysSavingsTotal() async {
    final logs = await getLogsForToday();
    double total = 0;
    for (final log in logs) {
      if (log.amount != null) total += log.amount!;
    }
    return total;
  }

  /// Count streak for a habit (consecutive days starting today)
  Future<int> getHabitStreak(String habitId) async {
    final logs = await getLogsForHabit(habitId);
    if (logs.isEmpty) return 0;

    // Normalize to date-only for easy comparison
    final dates = logs
        .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
        .toSet();

    int streak = 0;
    DateTime cursor = DateTime.now();
    while (true) {
      final day = DateTime(cursor.year, cursor.month, cursor.day);
      if (dates.contains(day)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
