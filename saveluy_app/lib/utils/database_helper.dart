import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/habit.dart';
import '../models/dailyLog.dart';

class DatabaseHelper {
  // Singleton Pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Database name & version
  static const String _dbName = 'save_luy.db';
  static const int _dbVersion = 2; 

  /* -------------------- TABLE & COLUMNS -------------------- */

  static const String tableHabit = 'habits';
  static const String tableLogs = 'daily_logs';

  // Habit Column Names
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colQuickLogText = 'quickLogText';
  static const String colIcon = 'icon';
  static const String colShowInQuickAdd = 'showInQuickAdd';
  static const String colCategoryType = 'categoryType';

  // Public database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createLogsTable(db);
        }
      },
    );
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create Habit Table
    await db.execute('''
      CREATE TABLE $tableHabit (
        $colId TEXT PRIMARY KEY,
        $colName TEXT NOT NULL,
        $colQuickLogText TEXT,
        $colIcon TEXT NOT NULL,
        $colShowInQuickAdd INTEGER NOT NULL,
        $colCategoryType TEXT NOT NULL
      )
    ''');
    
    // Create Logs Table
    await _createLogsTable(db);
  }

  /// Helper to create Logs table (used in onCreate and onUpgrade)
  Future<void> _createLogsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableLogs (
        id TEXT PRIMARY KEY,
        habitId TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        amount REAL,
        FOREIGN KEY (habitId) REFERENCES $tableHabit ($colId) ON DELETE CASCADE
      )
    ''');
  }

  /* -------------------- HABIT CRUD OPERATIONS -------------------- */

  /// CREATE: Insert Habit
  Future<int> insertHabit(Map<String, dynamic> habitMap) async {
    Database db = await database;
    return await db.insert(
      tableHabit,
      habitMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// READ: Get all habits (as Maps)
  Future<List<Map<String, dynamic>>> getHabitMapList() async {
    Database db = await database;
    return await db.query(tableHabit);
  }

  /// READ: Get habit by id
  Future<Map<String, dynamic>?> getHabitById(String id) async {
    Database db = await database;
    final result = await db.query(
      tableHabit, // Ensure this constant is 'habits'
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }

  /// READ: Get habits filtered by Category
  Future<List<Habit>> getHabitsByCategory(CategoryType type) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableHabit,
      where: '$colCategoryType = ?',
      whereArgs: [type.name], 
    );

    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  /// READ: Only get habits that the user wants in "Quick Add"
  Future<List<Habit>> getQuickAddHabits() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableHabit,
      where: '$colShowInQuickAdd = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  /// UPDATE: Update Habit
  Future<int> updateHabit(Map<String, dynamic> habitMap) async {
    Database db = await database;
    return await db.update(
      tableHabit,
      habitMap,
      where: '$colId = ?',
      whereArgs: [habitMap[colId]],
    );
  }

  /// DELETE: Delete Habit
  Future<int> deleteHabit(String id) async {
    Database db = await database;
    return await db.delete(
      tableHabit,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  /* -------------------- DAILY LOG OPERATIONS -------------------- */

  /// CREATE: Insert a new completion log using the DailyLog model
  Future<int> insertDailyLog(DailyLog log) async {
    Database db = await database;
    return await db.insert(
      tableLogs, 
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// READ: Check if a habit was logged today
  Future<bool> isHabitLoggedToday(String habitId) async {
    Database db = await database;
    String today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
    
    final result = await db.query(
      tableLogs,
      where: 'habitId = ? AND date LIKE ?',
      whereArgs: [habitId, '$today%'],
    );
    
    return result.isNotEmpty;
  }

  /// READ: Get all logs for a specific habit
  Future<List<DailyLog>> getLogsForHabit(String habitId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableLogs,
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => DailyLog.fromMap(maps[i]));
  }
}