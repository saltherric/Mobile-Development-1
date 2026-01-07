import '../../utils/databaseHelper.dart';
import '../../models/category.dart';

class CategoryRepository {
  final DatabaseHelper _storage = DatabaseHelper();

  /* -------------------- CREATE -------------------- */

  Future<void> addCategory(Category category) async {
    await _storage.insertCategory(category.toMap());
  }

  /* -------------------- READ -------------------- */

  Future<List<Category>> getAllCategories() async {
    final List<Map<String, dynamic>> mapList =
        await _storage.getCategoryMapList();

    return mapList.map((map) => Category.fromMap(map)).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final map = await _storage.getCategoryById(id);
    if (map == null) return null;
    return Category.fromMap(map);
  }

  /* -------------------- UPDATE -------------------- */

  Future<void> updateCategory(Category category) async {
    await _storage.updateCategory(category.toMap());
  }

  /* -------------------- DELETE -------------------- */

  Future<void> deleteCategory(String id) async {
    await _storage.deleteCategory(id);
  }
}
