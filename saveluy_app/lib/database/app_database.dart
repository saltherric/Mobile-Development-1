import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  
  factory AppDatabase() => _instance;
  
  AppDatabase._internal();

  static const String _habitsKey = 'app_habits';
  static const String _categoriesKey = 'app_categories';
  static const String _dailyLogsKey = 'app_daily_logs';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // ============ PRIVATE HELPER METHODS ============
  Future<void> _saveList(String key, List<Map<String, dynamic>> items) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(items);
    await prefs.setString(key, jsonString);
  }

  /// Load a list of items from JSON
  /// Returns empty list if nothing is stored yet
  Future<List<Map<String, dynamic>>> _loadList(String key) async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(key);
    
    if (jsonString == null) {
      return []; // Return empty list if no data found
    }
    
    final decoded = jsonDecode(jsonString);
    return List<Map<String, dynamic>>.from(decoded);
  }

  /// Delete all data stored under a key
  Future<void> _clearKey(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  // ============ HABIT METHODS ============
  Future<void> saveHabit(Map<String, dynamic> habit) async {
    final habits = await getAllHabits();
    
    // Find if habit with this ID already exists
    final index = habits.indexWhere((h) => h['id'] == habit['id']);
    
    if (index >= 0) {
      // Update existing habit
      habits[index] = habit;
    } else {
      // Add new habit
      habits.add(habit);
    }
    
    await _saveList(_habitsKey, habits);
  }

  /// Get all habits stored in the app
  Future<List<Map<String, dynamic>>> getAllHabits() async {
    return await _loadList(_habitsKey);
  }

  /// Get a single habit by its ID
  Future<Map<String, dynamic>?> getHabitById(String id) async {
    final habits = await getAllHabits();
    try {
      return habits.firstWhere((h) => h['id'] == id);
    } catch (e) {
      return null; // Habit not found
    }
  }

  /// Delete a habit and all its logs
  Future<void> deleteHabit(String habitId) async {
    // Remove the habit itself
    final habits = await getAllHabits();
    habits.removeWhere((h) => h['id'] == habitId);
    await _saveList(_habitsKey, habits);
    
    // Also remove all logs for this habit
    final logs = await getAllDailyLogs();
    logs.removeWhere((log) => log['habitId'] == habitId);
    await _saveList(_dailyLogsKey, logs);
  }

  /// Delete all habits and logs (useful for reset/testing)
  Future<void> clearAllHabits() async {
    await _clearKey(_habitsKey);
    await _clearKey(_dailyLogsKey);
  }

  // ============ CATEGORY METHODS ============

  /// Save a new category or update existing one
  Future<void> saveCategory(Map<String, dynamic> category) async {
    final categories = await getAllCategories();
    
    // Find if category with this ID already exists
    final index = categories.indexWhere((c) => c['id'] == category['id']);
    
    if (index >= 0) {
      // Update existing category
      categories[index] = category;
    } else {
      // Add new category
      categories.add(category);
    }
    
    await _saveList(_categoriesKey, categories);
  }

  /// Get all categories stored in the app
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await _loadList(_categoriesKey);
  }

  /// Get a single category by its ID
  Future<Map<String, dynamic>?> getCategoryById(String id) async {
    final categories = await getAllCategories();
    try {
      return categories.firstWhere((c) => c['id'] == id);
    } catch (e) {
      return null; // Category not found
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    final categories = await getAllCategories();
    categories.removeWhere((c) => c['id'] == categoryId);
    await _saveList(_categoriesKey, categories);
  }

  /// Delete all categories
  Future<void> clearAllCategories() async {
    await _clearKey(_categoriesKey);
  }

  // ============ DAILY LOG METHODS ============
  Future<void> saveDailyLog(Map<String, dynamic> log) async {
    final logs = await getAllDailyLogs();
    
    // Find if log with this ID already exists
    final index = logs.indexWhere((l) => l['id'] == log['id']);
    
    if (index >= 0) {
      // Update existing log
      logs[index] = log;
    } else {
      // Add new log
      logs.add(log);
    }
    
    await _saveList(_dailyLogsKey, logs);
  }

  /// Get all daily logs stored in the app
  Future<List<Map<String, dynamic>>> getAllDailyLogs() async {
    return await _loadList(_dailyLogsKey);
  }

  /// Get all logs for a specific habit
  /// Useful for showing habit history and streaks
  Future<List<Map<String, dynamic>>> getLogsForHabit(String habitId) async {
    final allLogs = await getAllDailyLogs();
    return allLogs.where((log) => log['habitId'] == habitId).toList();
  }

  /// Get logs for a specific date
  /// Useful for showing "today's" completions
  Future<List<Map<String, dynamic>>> getLogsForDate(DateTime date) async {
    final allLogs = await getAllDailyLogs();
    final dateString = date.toString().split(' ')[0]; // Get YYYY-MM-DD
    
    return allLogs.where((log) {
      final logDate = log['date'].toString().split(' ')[0];
      return logDate == dateString;
    }).toList();
  }

  /// Delete a single daily log
  Future<void> deleteDailyLog(String logId) async {
    final logs = await getAllDailyLogs();
    logs.removeWhere((l) => l['id'] == logId);
    await _saveList(_dailyLogsKey, logs);
  }

  /// Delete all daily logs for a specific habit
  /// Useful when deleting a habit
  Future<void> deleteLogsForHabit(String habitId) async {
    final logs = await getAllDailyLogs();
    logs.removeWhere((log) => log['habitId'] == habitId);
    await _saveList(_dailyLogsKey, logs);
  }

  /// Delete all daily logs
  Future<void> clearAllLogs() async {
    await _clearKey(_dailyLogsKey);
  }

  // ============ RESET METHODS ============
  Future<void> deleteEverything() async {
    await _clearKey(_habitsKey);
    await _clearKey(_categoriesKey);
    await _clearKey(_dailyLogsKey);
  }

  /// Get basic statistics about stored data
  /// Useful for debugging and understanding what's stored
  Future<Map<String, dynamic>> getStats() async {
    return {
      'totalHabits': (await getAllHabits()).length,
      'totalCategories': (await getAllCategories()).length,
      'totalLogs': (await getAllDailyLogs()).length,
    };
  }
}
