import 'package:flutter/material.dart';
import '../../../models/habit.dart';
import '../../../models/category.dart';
import '../../../data/repositories/habitRepository.dart';
import '../../../data/repositories/categoryRepository.dart';
import 'habit_form.dart';
import 'category_form.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({super.key});

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  static const Color _primaryGreen = Color(0xFF20C997);
  static const Color _background = Color(0xFFF5F7FA);

  final HabitRepository _habitRepo = HabitRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();

  List<Habit> _userHabits = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final habits = await _habitRepo.getAllHabits();
    final categories = await _categoryRepo.getAllCategories();

    if (!mounted) return;

    setState(() {
      _userHabits = habits;
      _categories = categories;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAddHabit() async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(builder: (_) => const HabitFormScreen()),
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
      MaterialPageRoute(builder: (_) => HabitFormScreen(habit: habit)),
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

  Future<void> _deleteHabit(Habit habit) async {
    final confirmed = await showDialog<bool>(
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

    if (confirmed != true) return;

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

  void _navigateToAddCategory() async {
    final result = await Navigator.push<Category>(
      context,
      MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
    );

    if (result == null) return;

    await _categoryRepo.addCategory(result);
    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category saved successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToEditCategory(Category category) async {
    final result = await Navigator.push<Category>(
      context,
      MaterialPageRoute(builder: (_) => CategoryFormScreen(category: category)),
    );

    if (result == null) return;

    await _categoryRepo.updateCategory(result);
    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteCategoryDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _categoryRepo.deleteCategory(category.id);
              if (!mounted) return;
              Navigator.pop(context);
              await _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),

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

            _buildAddButton(text: 'Add New Habit', onTap: _navigateToAddHabit),
            const SizedBox(height: 20),

            _buildSectionLabel('YOUR HABITS'),
            const SizedBox(height: 12),
            if (_userHabits.isEmpty)
              _buildEmptyCard('No habits created yet')
            else
              ..._userHabits.map((habit) => _buildHabitCard(habit)),

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

            _buildAddButton(
              text: 'Add New Category',
              onTap: _navigateToAddCategory,
            ),
            const SizedBox(height: 20),

            _buildSectionLabel('YOUR CATEGORIES'),
            const SizedBox(height: 12),
            if (_categories.isEmpty)
              _buildEmptyCard('No custom categories yet')
            else
              ..._categories.map((category) => _buildCategoryCard(category)),

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

  Widget _buildHabitCard(Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(habit.icon.iconData, color: _primaryGreen, size: 24),
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
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  habit.quickLogText,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
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

  Widget _buildCategoryCard(Category category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(category.icon.icon, color: category.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.grey.shade600,
            onPressed: () => _navigateToEditCategory(category),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade400,
            onPressed: () => _showDeleteCategoryDialog(category),
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
