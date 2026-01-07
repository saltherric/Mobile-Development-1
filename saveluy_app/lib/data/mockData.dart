import 'package:uuid/uuid.dart';
import '../models/homeData.dart';
import '../models/analysisData.dart';

const uuid = Uuid();

class MockData {
  // ==================== HOME DATA ====================
  
  static List<CategoryActivityData> getDefaultCategoryActivities() {
    return [
      CategoryActivityData(
        id: uuid.v4(),
        homeDataId: 'home_data_default',
        imagePath: 'assets/images/categories/foodNdrink.png',
        label: 'Food & Drink',
        status: 'High Activity',
        filledDots: 4,
        progress: 0.9,
        accentColorHex: '#FFE53935',
      ),
      CategoryActivityData(
        id: uuid.v4(),
        homeDataId: 'home_data_default',
        imagePath: 'assets/images/categories/A_piggy_bank.png',
        label: 'Daily Savings',
        status: 'High Activity',
        filledDots: 5,
        progress: 1,
        accentColorHex: '#FF20C997',
      ),
      CategoryActivityData(
        id: uuid.v4(),
        homeDataId: 'home_data_default',
        imagePath: 'assets/images/onlineShopping.png',
        label: 'Impulse Buying',
        status: 'Controlled',
        filledDots: 2,
        progress: 0.35,
        accentColorHex: '#FFFFB300',
      ),
    ];
  }

  static Map<String, dynamic> getDefaultHomeDataParams() {
    return {
      'overallScore': 85,
      'overallMessage': 'Great! Your habits are improving.',
    };
  }

  // ==================== ANALYSIS DATA ====================

  static List<StreakItem> getDefaultStreaks() {
    return [
      StreakItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/coffee.png',
        title: 'Coffee Purchased Avoided',
        subtitle: 'No Coffee Today',
        streakCount: 3,
        category: 'Food & Drink',
      ),
      StreakItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/homeCookMeal.png',
        title: 'Home Cooked Meal',
        subtitle: 'Avoided Dining Out',
        streakCount: 4,
        category: 'Food & Drink',
      ),
      StreakItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/pigBank.png',
        title: 'Daily Savings Log',
        subtitle: 'Saved RM5 Today',
        streakCount: 5,
        category: 'Daily Savings',
      ),
      StreakItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/onlineShopping.png',
        title: 'Online Shopping Avoided',
        subtitle: 'Avoided Impulse Buy',
        streakCount: 7,
        category: 'Impulse Buying',
      ),
      StreakItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/snacks.png',
        title: 'Avoided Buying Snacks',
        subtitle: 'Saved on Junk Food',
        streakCount: 2,
        category: 'Food & Drink',
      ),
    ];
  }

  static List<CategoryItem> getDefaultCategories() {
    return [
      CategoryItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/categories/foodNdrink.png',
        iconColorHex: '#FFF44336',
        label: 'Food & Drink',
        status: 'High Activity',
        statusColorHex: '#FFF44336',
        filledDots: 4,
        progress: 0.9,
        accentColorHex: '#FFFFE53935',
      ),
      CategoryItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/categories/A_piggy_bank.png',
        iconColorHex: '#FF20C997',
        label: 'Daily Savings',
        status: 'High Activity',
        statusColorHex: '#FF20C997',
        filledDots: 5,
        progress: 1,
        accentColorHex: '#FF20C997',
      ),
      CategoryItem(
        id: uuid.v4(),
        analysisDataId: 'analysis_data_default',
        imagePath: 'assets/images/onlineShopping.png',
        iconColorHex: '#FFFFB300',
        label: 'Impulse Buying',
        status: 'Controlled',
        statusColorHex: '#FFFFB300',
        filledDots: 2,
        progress: 0.35,
        accentColorHex: '#FFFFB300',
      ),
    ];
  }
}
