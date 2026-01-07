import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

const uuid = Uuid();

class SampleData {
  static final db = AppDatabase();

  // ============ SAMPLE CATEGORIES ============

  static final Map<String, dynamic> categoryFoodAndDrink = {
    'id': 'cat_food_drink',
    'name': 'Food & Drink',
    'icon': 'food',
    'colorHex': '#FFE53935', // Red color
  };

  static final Map<String, dynamic> categoryDailySavings = {
    'id': 'cat_daily_savings',
    'name': 'Daily Savings',
    'icon': 'savings',
    'colorHex': '#FF20C997', // Green color
  };

  static final Map<String, dynamic> categoryImpulseBuying = {
    'id': 'cat_impulse_buying',
    'name': 'Impulse Buying',
    'icon': 'shopping',
    'colorHex': '#FFFFB300', // Amber/Yellow color
  };

  // ============ SAMPLE HABITS ============

  static final Map<String, dynamic> habitCoffeeAvoided = {
    'id': 'habit_coffee',
    'name': 'Coffee Purchased Avoided',
    'quickLogText': 'No Coffee Today',
    'icon': 'coffee',
    'showInQuickAdd': 1,
    'categoryType': 'avoidance',
  };

  static final Map<String, dynamic> habitHomeCookedMeal = {
    'id': 'habit_home_meal',
    'name': 'Home Cooked Meal',
    'quickLogText': 'Avoided Dining Out',
    'icon': 'home',
    'showInQuickAdd': 1,
    'categoryType': 'avoidance',
  };

  static final Map<String, dynamic> habitDailySavings = {
    'id': 'habit_daily_savings',
    'name': 'Daily Savings Log',
    'quickLogText': 'Saved RM5 Today',
    'icon': 'piggyBank',
    'showInQuickAdd': 1,
    'categoryType': 'saving',
  };

  static final Map<String, dynamic> habitOnlineShoppingAvoided = {
    'id': 'habit_online_shopping',
    'name': 'Online Shopping Avoided',
    'quickLogText': 'Avoided Impulse Buy',
    'icon': 'shoppingCart',
    'showInQuickAdd': 1,
    'categoryType': 'avoidance',
  };

  static final Map<String, dynamic> habitSnacksAvoided = {
    'id': 'habit_snacks',
    'name': 'Avoided Buying Snacks',
    'quickLogText': 'Saved on Junk Food',
    'icon': 'coffee',
    'showInQuickAdd': 1,
    'categoryType': 'avoidance',
  };

  // ============ SAMPLE DAILY LOGS ============

  static List<Map<String, dynamic>> generateSampleLogs() {
    final today = DateTime.now();
    
    return [
      // Coffee Avoided - 3 day streak
      {
        'id': uuid.v4(),
        'habitId': 'habit_coffee',
        'date': today.subtract(Duration(days: 2)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_coffee',
        'date': today.subtract(Duration(days: 1)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_coffee',
        'date': today.toIso8601String(),
        'notes': null,
        'amount': null,
      },

      // Home Cooked Meal - 4 day streak
      {
        'id': uuid.v4(),
        'habitId': 'habit_home_meal',
        'date': today.subtract(Duration(days: 3)).toIso8601String(),
        'notes': 'Cooked pasta',
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_home_meal',
        'date': today.subtract(Duration(days: 2)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_home_meal',
        'date': today.subtract(Duration(days: 1)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_home_meal',
        'date': today.toIso8601String(),
        'notes': null,
        'amount': null,
      },

      // Daily Savings - 5 day streak (highest!)
      {
        'id': uuid.v4(),
        'habitId': 'habit_daily_savings',
        'date': today.subtract(Duration(days: 4)).toIso8601String(),
        'notes': null,
        'amount': 5.0,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_daily_savings',
        'date': today.subtract(Duration(days: 3)).toIso8601String(),
        'notes': null,
        'amount': 10.0,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_daily_savings',
        'date': today.subtract(Duration(days: 2)).toIso8601String(),
        'notes': null,
        'amount': 5.0,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_daily_savings',
        'date': today.subtract(Duration(days: 1)).toIso8601String(),
        'notes': null,
        'amount': 3.0,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_daily_savings',
        'date': today.toIso8601String(),
        'notes': null,
        'amount': 5.0,
      },

      // Online Shopping Avoided - 7 day streak
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.subtract(Duration(days: 6)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.subtract(Duration(days: 5)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.subtract(Duration(days: 4)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.subtract(Duration(days: 3)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.subtract(Duration(days: 2)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.subtract(Duration(days: 1)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_online_shopping',
        'date': today.toIso8601String(),
        'notes': null,
        'amount': null,
      },

      // Snacks Avoided - 2 day streak
      {
        'id': uuid.v4(),
        'habitId': 'habit_snacks',
        'date': today.subtract(Duration(days: 1)).toIso8601String(),
        'notes': null,
        'amount': null,
      },
      {
        'id': uuid.v4(),
        'habitId': 'habit_snacks',
        'date': today.toIso8601String(),
        'notes': null,
        'amount': null,
      },
    ];
  }

  // ============ INITIALIZATION ============
  static Future<void> initializeApp() async {
    // Check if we already have data
    final existingHabits = await db.getAllHabits();
    
    if (existingHabits.isNotEmpty) {
      print('✓ Data already exists, skipping initialization');
      return;
    }

    print('✓ First time setup - loading sample data...');

    try {
      // Save categories
      await db.saveCategory(categoryFoodAndDrink);
      await db.saveCategory(categoryDailySavings);
      await db.saveCategory(categoryImpulseBuying);
      print('✓ Categories saved');

      // Save habits
      await db.saveHabit(habitCoffeeAvoided);
      await db.saveHabit(habitHomeCookedMeal);
      await db.saveHabit(habitDailySavings);
      await db.saveHabit(habitOnlineShoppingAvoided);
      await db.saveHabit(habitSnacksAvoided);
      print('✓ Habits saved');

      // Save sample logs
      final logs = generateSampleLogs();
      for (final log in logs) {
        await db.saveDailyLog(log);
      }
      print('✓ Sample logs saved');

      // Print what we have
      final stats = await db.getStats();
      print('✓ Initialization complete!');
      print('  - Habits: ${stats['totalHabits']}');
      print('  - Categories: ${stats['totalCategories']}');
      print('  - Logs: ${stats['totalLogs']}');
    } catch (e) {
      print('✗ Error initializing data: $e');
    }
  }

  static Future<void> resetAndReload() async {
    print('Resetting all data...');
    await db.deleteEverything();
    await initializeApp();
  }
}
