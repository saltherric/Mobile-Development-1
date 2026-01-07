import 'package:uuid/uuid.dart';
import '../../models/analysisData.dart';
import '../../utils/databaseHelper.dart';

const uuid = Uuid();

class AnalysisDataRepository {
  final DatabaseHelper _storage = DatabaseHelper();

  /// Save Analysis Data to database
  Future<void> saveAnalysisData(AnalysisData analysisData) async {
    // Insert analysis data
    await _storage.insertAnalysisData(analysisData.toMap());

    // Delete old streaks and categories and insert new ones
    await _storage.deleteAnalysisData(analysisData.id);
    await _storage.insertAnalysisData(analysisData.toMap());

    for (var streak in analysisData.streaks) {
      await _storage.insertStreakItem(streak.toMap());
    }

    for (var category in analysisData.categories) {
      await _storage.insertAnalysisCategoryItem(category.toMap());
    }
  }

  /// Get Analysis Data with all streaks and categories
  Future<AnalysisData?> getAnalysisData(String id) async {
    final analysisDataMap = await _storage.getAnalysisData(id);
    if (analysisDataMap == null) return null;

    final streaksMapList = await _storage.getStreakItems(id);
    final streaks = streaksMapList
        .map((map) => StreakItem.fromMap(map))
        .toList();

    final categoriesMapList = await _storage.getAnalysisCategoryItems(id);
    final categories = categoriesMapList
        .map((map) => CategoryItem.fromMap(map))
        .toList();

    return AnalysisData(
      id: id,
      streaks: streaks,
      categories: categories,
    );
  }

  /// Create new Analysis Data with default ID
  AnalysisData createNewAnalysisData({
    required List<StreakItem> streaks,
    required List<CategoryItem> categories,
  }) {
    return AnalysisData(
      id: 'analysis_data_default', // Use a fixed ID for the main analysis data
      streaks: streaks,
      categories: categories,
    );
  }
}
