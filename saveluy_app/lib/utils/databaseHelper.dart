import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  // Singleton pattern - only one instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // ============ HELPER METHODS ============

  /// Save JSON list to a key
  Future<void> _saveList(String key, List<Map<String, dynamic>> items) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(items));
  }

  /// Load JSON list from a key
  Future<List<Map<String, dynamic>>> _loadList(String key) async {
    final prefs = await _prefs;
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  /// Save a single JSON object
  Future<void> _saveObject(String key, Map<String, dynamic> object) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(object));
  }

  /// Load a single JSON object
  Future<Map<String, dynamic>?> _loadObject(String key) async {
    final prefs = await _prefs;
    final data = prefs.getString(key);
    if (data == null) return null;
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  /// Delete a key
  Future<void> _delete(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  // ============ HABITS ============

  Future<void> insertHabit(Map<String, dynamic> habit) async {
    final habits = await getHabitMapList();
    final index = habits.indexWhere((h) => h['id'] == habit['id']);
    
    if (index >= 0) {
      habits[index] = habit;
    } else {
      habits.add(habit);
    }
    
    await _saveList('habits', habits);
  }

  Future<List<Map<String, dynamic>>> getHabitMapList() async {
    return await _loadList('habits');
  }

  Future<Map<String, dynamic>?> getHabitById(String id) async {
    final habits = await getHabitMapList();
    try {
      return habits.firstWhere((h) => h['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateHabit(Map<String, dynamic> habit) async {
    await insertHabit(habit);
  }

  Future<void> deleteHabit(String id) async {
    final habits = await getHabitMapList();
    habits.removeWhere((h) => h['id'] == id);
    await _saveList('habits', habits);
    
    // Delete related logs
    final logs = await _loadList('daily_logs');
    logs.removeWhere((log) => log['habitId'] == id);
    await _saveList('daily_logs', logs);
  }

  // ============ DAILY LOGS ============

  Future<void> insertDailyLog(Map<String, dynamic> log) async {
    final logs = await _loadList('daily_logs');
    final index = logs.indexWhere((l) => l['id'] == log['id']);
    
    if (index >= 0) {
      logs[index] = log;
    } else {
      logs.add(log);
    }
    
    await _saveList('daily_logs', logs);
  }

  Future<List<Map<String, dynamic>>> getDailyLogs(String habitId) async {
    final allLogs = await _loadList('daily_logs');
    return allLogs.where((log) => log['habitId'] == habitId).toList();
  }

  // ============ HOME DATA ============

  Future<void> insertHomeData(Map<String, dynamic> homeData) async {
    await _saveObject('home_data_${homeData['id']}', homeData);
  }

  Future<Map<String, dynamic>?> getHomeData(String id) async {
    return await _loadObject('home_data_$id');
  }

  Future<void> insertCategoryActivity(Map<String, dynamic> category) async {
    final homeDataId = category['homeDataId'];
    final categories = await getCategoryActivities(homeDataId);
    
    final index = categories.indexWhere((c) => c['id'] == category['id']);
    if (index >= 0) {
      categories[index] = category;
    } else {
      categories.add(category);
    }
    
    await _saveList('categories_$homeDataId', categories);
  }

  Future<List<Map<String, dynamic>>> getCategoryActivities(String homeDataId) async {
    return await _loadList('categories_$homeDataId');
  }

  Future<void> deleteHomeData(String id) async {
    await _delete('home_data_$id');
    await _delete('categories_$id');
  }

  // ============ ANALYSIS DATA ============

  Future<void> insertAnalysisData(Map<String, dynamic> analysisData) async {
    await _saveObject('analysis_data_${analysisData['id']}', analysisData);
  }

  Future<Map<String, dynamic>?> getAnalysisData(String id) async {
    return await _loadObject('analysis_data_$id');
  }

  Future<void> insertStreakItem(Map<String, dynamic> streak) async {
    final analysisDataId = streak['analysisDataId'];
    final streaks = await getStreakItems(analysisDataId);
    
    final index = streaks.indexWhere((s) => s['id'] == streak['id']);
    if (index >= 0) {
      streaks[index] = streak;
    } else {
      streaks.add(streak);
    }
    
    await _saveList('streaks_$analysisDataId', streaks);
  }

  Future<List<Map<String, dynamic>>> getStreakItems(String analysisDataId) async {
    return await _loadList('streaks_$analysisDataId');
  }

  Future<void> insertAnalysisCategoryItem(Map<String, dynamic> category) async {
    final analysisDataId = category['analysisDataId'];
    final categories = await getAnalysisCategoryItems(analysisDataId);
    
    final index = categories.indexWhere((c) => c['id'] == category['id']);
    if (index >= 0) {
      categories[index] = category;
    } else {
      categories.add(category);
    }
    
    await _saveList('analysis_categories_$analysisDataId', categories);
  }

  Future<List<Map<String, dynamic>>> getAnalysisCategoryItems(String analysisDataId) async {
    return await _loadList('analysis_categories_$analysisDataId');
  }

  Future<void> deleteAnalysisData(String id) async {
    await _delete('analysis_data_$id');
    await _delete('streaks_$id');
    await _delete('analysis_categories_$id');
  }
}
