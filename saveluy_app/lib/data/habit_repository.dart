import '../utils/database_helper.dart';
import '../../../models/habit.dart';

class HabitRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /* -------------------- CREATE -------------------- */

  Future<void> addHabit(Habit habit) async {
    await _dbHelper.insertHabit(habit.toMap());
  }

  /* -------------------- READ -------------------- */

  Future<List<Habit>> getAllHabits() async {
    final List<Map<String, dynamic>> mapList =
        await _dbHelper.getHabitMapList();

    return mapList.map((map) => Habit.fromMap(map)).toList();
  }

  Future<Habit?> getHabitById(String id) async {
    final map = await _dbHelper.getHabitById(id);
    if (map == null) return null;
    return Habit.fromMap(map);
  }

  /* -------------------- UPDATE -------------------- */

  Future<void> updateHabit(Habit habit) async {
    await _dbHelper.updateHabit(habit.toMap());
  }

  /* -------------------- DELETE -------------------- */

  Future<void> deleteHabit(String id) async {
    await _dbHelper.deleteHabit(id);
  }

}
