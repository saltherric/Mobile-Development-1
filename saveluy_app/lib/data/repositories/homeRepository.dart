import 'package:uuid/uuid.dart';
import '../../models/homeData.dart';
import '../../utils/databaseHelper.dart';

const uuid = Uuid();

class HomeDataRepository {
  final DatabaseHelper _storage = DatabaseHelper();

  /// Save Home Data to database
  Future<void> saveHomeData(HomeData homeData) async {
    // Insert home data
    await _storage.insertHomeData(homeData.toMap());

    // Delete old category activities and insert new ones
    await _storage.deleteHomeData(homeData.id);
    await _storage.insertHomeData(homeData.toMap());

    for (var category in homeData.categoryActivities) {
      await _storage.insertCategoryActivity(category.toMap());
    }
  }

  /// Get Home Data with all category activities
  Future<HomeData?> getHomeData(String id) async {
    final homeDataMap = await _storage.getHomeData(id);
    if (homeDataMap == null) return null;

    final categoriesMapList = await _storage.getCategoryActivities(id);
    final categories = categoriesMapList
        .map((map) => CategoryActivityData.fromMap(map))
        .toList();

    final homeData = HomeData.fromMap(homeDataMap);
    return HomeData(
      id: homeData.id,
      overallScore: homeData.overallScore,
      overallMessage: homeData.overallMessage,
      categoryActivities: categories,
    );
  }

  /// Create new Home Data with default ID
  HomeData createNewHomeData({
    required double overallScore,
    required String overallMessage,
    required List<CategoryActivityData> categoryActivities,
  }) {
    return HomeData(
      id: 'home_data_default', // Use a fixed ID for the main home data
      overallScore: overallScore,
      overallMessage: overallMessage,
      categoryActivities: categoryActivities,
    );
  }
}
