import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Database name & version
  static const String _dbName = 'save_luy.db';
  static const int _dbVersion = 2; // Incremented version because we added a table

  /* -------------------- TABLE & COLUMNS -------------------- */

  // Table name
  static const String tableHabit = 'habits';
  static const String tableLogs = 'habit_logs';

  // Column names
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colQuickLogText = 'quickLogText';
  static const String colIcon = 'icon';
  static const String colShowInQuickAdd = 'showInQuickAdd';
  static const String colCategoryType = 'categoryType';

  // Log Columns
  static const String colLogId = 'logId';
  static const String colHabitId = 'habitId';
  static const String colDate = 'date'; // Store as ISO8601 String

  /// Public database getter
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
      }
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

  Future<void> _createLogsTable(Database db) async {
    await db.execute('''
    CREATE TABLE daily_logs (
      id TEXT PRIMARY KEY,
      habitId TEXT NOT NULL,
      date TEXT NOT NULL,
      notes TEXT,
      amount REAL,
      FOREIGN KEY (habitId) REFERENCES habits (id) ON DELETE CASCADE
    )
  ''');
  }

  /// READ: Only get habits that the user wants in "Quick Add"
  Future<List<Map<String, dynamic>>> getQuickAddHabitMaps() async {
    Database db = await database;
    // We filter where colShowInQuickAdd is 1 (True)
    return await db.query(
      tableHabit,
      where: '$colShowInQuickAdd = ?',
      whereArgs: [1],
    );
  }

  

  /// CREATE: Insert a new completion log
  Future<int> insertLog(String habitId) async {
    Database db = await database;
    return await db.insert(tableLogs, {
      colHabitId: habitId,
      colDate: DateTime.now().toIso8601String(),
    });
  }

  /// READ: Check if a habit was logged today
  Future<bool> isHabitLoggedToday(String habitId) async {
    Database db = await database;
    String today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
    
    final result = await db.query(
      tableLogs,
      where: '$colHabitId = ? AND $colDate LIKE ?',
      whereArgs: [habitId, '$today%'],
    );
    
    return result.isNotEmpty;
  }

  /* -------------------- CRUD OPERATIONS -------------------- */

  /// CREATE: Insert Habit
  Future<int> insertHabit(Map<String, dynamic> habitMap) async {
    Database db = await database;
    return await db.insert(
      tableHabit,
      habitMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// READ: Get all habits
  Future<List<Map<String, dynamic>>> getHabitMapList() async {
    Database db = await database;
    return await db.query(tableHabit);
  }

  /// READ: Get habit by id
  Future<Map<String, dynamic>?> getHabitById(String id) async {
    Database db = await database;
    final result = await db.query(
      tableHabit,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
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


  /// Close database (optional)
//   Future<void> close() async {
//     final db = _database;
//     if (db != null) {
//       await db.close();
//       _database = null;
//     }
//   }
}
