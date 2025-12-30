import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../../models/category.dart';

class CategoryJsonRepository {
  static const String _fileName = 'categories.json';

  /// Get the local file path
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  /// Load categories from JSON file
  Future<List<Category>> loadCategories() async {
    try {
      final file = await _getLocalFile();

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList
          .map((map) => Category.fromMap(map))
          .toList();
    } catch (e) {
      // Fail-safe: never crash UI
      return [];
    }
  }

  /// Save categories to JSON file
  Future<void> saveCategories(List<Category> categories) async {
    final file = await _getLocalFile();

    final jsonList = categories
        .map((category) => category.toMap())
        .toList();

    final jsonString = json.encode(jsonList);

    await file.writeAsString(jsonString);
  }



}
