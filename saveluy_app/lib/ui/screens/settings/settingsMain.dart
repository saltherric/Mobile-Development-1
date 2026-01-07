import 'package:flutter/material.dart';
import '../../../models/habit.dart';
import '../../../models/analysisData.dart';
import '../../../data/repositories/habitRepository.dart';
import '../../../data/repositories/analysisRepository.dart';
import '../../../data/mockData.dart';
import 'habit_form.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({super.key});

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  static const Color _primaryGreen = Color(0xFF20C997);
  static const Color _background = Color(0xFFF5F7FA);

  final HabitRepository _habitRepo = HabitRepository();
  final AnalysisDataRepository _analysisRepo = AnalysisDataRepository();

  List<Habit> _userHabits = [];
  List<CategoryItem> _defaultCategories = [];
  List<CategoryItem> _userCategories = [];
  bool _isLoading = true;

  // Default habits based on the streaks from analysis
  final List<Map<String, dynamic>> _defaultHabits = [
    {
      'title': 'Coffee Purchase Avoided',
      'subtitle': 'No Coffee Today',
      'icon': Icons.coffee_outlined,
    },
    {
      'title': 'Home Cooked Meal',
      'subtitle': 'Avoided Dining Out',
      'icon': Icons.restaurant_outlined,
    },
    {
      'title': 'Daily Savings Log',
      'subtitle': 'Saved Money Today',
      'icon': Icons.savings_outlined,
    },
    {
      'title': 'Online Shopping Avoided',
      'subtitle': 'Avoided Impulse Buy',
      'icon': Icons.shopping_cart_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Load user habits
    final habits = await _habitRepo.getAllHabits();

    // Load categories from analysis data
    final analysisData = await _analysisRepo.getAnalysisData('analysis_data_default');
    List<CategoryItem> categories = [];
    
    if (analysisData == null) {
      // Create default data if it doesn't exist
      final defaultData = _analysisRepo.createNewAnalysisData(
        streaks: MockData.getDefaultStreaks(),
        categories: MockData.getDefaultCategories(),
      );
      await _analysisRepo.saveAnalysisData(defaultData);
      categories = defaultData.categories;
    } else {
      categories = analysisData.categories;
    }

    // Separate default and user categories (you can implement logic to differentiate)
    final defaultCats = MockData.getDefaultCategories().map((e) => e.label).toList();
    final defaultCategories = categories.where((c) => defaultCats.contains(c.label)).toList();
    final userCategories = categories.where((c) => !defaultCats.contains(c.label)).toList();

    if (!mounted) return;

    setState(() {
      _userHabits = habits;
      _defaultCategories = defaultCategories;
      _userCategories = userCategories;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAddHabit() async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (_) => const HabitFormScreen(),
      ),
    );

    if (result == null) return;

    await _habitRepo.addHabit(result);
    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habit saved successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _navigateToEditHabit(Habit habit) async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (_) => HabitFormScreen(habit: habit),
      ),
    );

    if (result == null) return;

    await _habitRepo.updateHabit(result);
    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habit updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteHabit(Habit habit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Delete "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await _habitRepo.deleteHabit(habit.id);
    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habit deleted'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============ HABITS SECTION ============
                  const Text(
                    'Habits',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add New Habit Button
                  _buildAddButton(
                    text: 'Add New Habit',
                    onTap: _navigateToAddHabit,
                  ),
                  const SizedBox(height: 20),

                  // Default Habits
                  _buildSectionLabel('DEFAULT HABITS'),
                  const SizedBox(height: 12),
                  ..._defaultHabits.map(
                    (habit) => _buildDefaultHabitCard(
                      title: habit['title'],
                      icon: habit['icon'],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Your Habits
                  _buildSectionLabel('YOUR HABITS'),
                  const SizedBox(height: 12),
                  if (_userHabits.isEmpty)
                    _buildEmptyCard('No custom habits yet')
                  else
                    ..._userHabits.map(
                      (habit) => _buildUserHabitCard(habit),
                    ),

                  const SizedBox(height: 32),

                  // ============ CATEGORIES SECTION ============
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add New Category Button
                  _buildAddButton(
                    text: 'Add New Category',
                    onTap: () {
                      // TODO: Implement add category
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add category feature coming soon'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Default Categories
                  _buildSectionLabel('DEFAULT CATEGORIES'),
                  const SizedBox(height: 12),
                  ..._defaultCategories.map(
                    (category) => _buildDefaultCategoryCard(category),
                  ),

                  const SizedBox(height: 24),

                  // Your Categories
                  _buildSectionLabel('YOUR CATEGORIES'),
                  const SizedBox(height: 12),
                  if (_userCategories.isEmpty)
                    _buildEmptyCard('No custom categories yet')
                  else
                    ..._userCategories.map(
                      (category) => _buildUserCategoryCard(category),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildAddButton({required String text, required VoidCallback onTap}) {
    return Material(
      color: _primaryGreen,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Color(0xFF9E9E9E),
      ),
    );
  }

  Widget _buildDefaultHabitCard({
    required String title,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.grey.shade600,
            onPressed: () {
              // Default habits are not editable
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Default habits cannot be edited'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserHabitCard(Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(habit.icon.iconData, color: _primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  habit.quickLogText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.grey.shade600,
            onPressed: () => _navigateToEditHabit(habit),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade400,
            onPressed: () => _deleteHabit(habit),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCategoryCard(CategoryItem category) {
    final iconColor = _parseColor(category.iconColorHex);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.category_outlined, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.grey.shade600,
            onPressed: () {
              // Default categories are not editable
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Default categories cannot be edited'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserCategoryCard(CategoryItem category) {
    final iconColor = _parseColor(category.iconColorHex);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.category_outlined, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.grey.shade600,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit category feature coming soon'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade400,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete category feature coming soon'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', '').replaceFirst('0x', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return _primaryGreen;
    }
  }
}
