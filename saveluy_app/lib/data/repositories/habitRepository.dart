import '../../utils/databaseHelper.dart';
import '../../models/habit.dart';

class HabitRepository {
  final DatabaseHelper _storage = DatabaseHelper();

  /* -------------------- CREATE -------------------- */

  Future<void> addHabit(Habit habit) async {
    await _storage.insertHabit(habit.toMap());
  }

  /* -------------------- READ -------------------- */

  Future<List<Habit>> getAllHabits() async {
    final List<Map<String, dynamic>> mapList =
        await _storage.getHabitMapList();

    return mapList.map((map) => Habit.fromMap(map)).toList();
  }

  Future<Habit?> getHabitById(String id) async {
    final map = await _storage.getHabitById(id);
    if (map == null) return null;
    return Habit.fromMap(map);
  }

  /* -------------------- UPDATE -------------------- */

  Future<void> updateHabit(Habit habit) async {
    await _storage.updateHabit(habit.toMap());
  }

  /* -------------------- DELETE -------------------- */

  Future<void> deleteHabit(String id) async {
    await _storage.deleteHabit(id);
  }

}
