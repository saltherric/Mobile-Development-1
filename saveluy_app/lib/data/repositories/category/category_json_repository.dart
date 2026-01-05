import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/category.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CategoryJsonRepository {
  static const String _path = 'assets/categories.json';

  /// Load categories from JSON
  Future<List<Category>> loadCategories() async {
    final jsonString = await rootBundle.loadString(_path);
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((e) => Category.fromJson(e)).toList();
  }

  /// Save categories (Mock – assets are read-only)
  Future<void> saveCategories(List<Category> categories) async {
    final jsonData =
        json.encode(categories.map((c) => c.toJson()).toList());

    // Assets cannot be written at runtime
    // Later: replace with SharedPreferences / File / SQLite
    print('Saved Categories JSON:');
    print(jsonData);
  }

  /// Add new category
  Future<List<Category>> addCategory(
      List<Category> current,
      Category newCategory,
      ) async {
    final updated = [...current, newCategory];
    await saveCategories(updated);
    return updated;
  }
}