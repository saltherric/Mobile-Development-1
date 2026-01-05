import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../models/category.dart';
import '../../../data/repositories/category/category_json_repository.dart';
import '../../widgets/category_card.dart';
import 'addCategory.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repo = CategoryJsonRepository();

  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    categories = await _repo.loadCategories();
    setState(() => isLoading = false);
  }

  /// Navigate to Add Category screen
  Future<void> _navigateToAddCategory() async {
    final result = await Navigator.push<Category>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCategoryScreen(),
      ),
    );

    if (result != null) {
      categories = await _repo.addCategory(categories, result);
      setState(() {});
    }
  }

  /// Show JSON preview dialog
  void _showJsonDialog() {
    final jsonData = const JsonEncoder.withIndent('  ')
        .convert(categories.map((e) => e.toJson()).toList());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Saved JSON Data'),
        content: SingleChildScrollView(
          child: Text(
            jsonData,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Setup'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories & Habits',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your financial habit structure',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  /// Add Category Button
                  OutlinedButton.icon(
                    onPressed: _navigateToAddCategory,
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Category'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Category List
                  if (categories.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No categories yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...categories.map(
                      (category) =>
                          CategoryCard(category: category),
                    ),

                  const SizedBox(height: 24),

                  /// Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.green),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Create categories that match your financial goals.',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _showJsonDialog,
                          icon:
                              const Icon(Icons.code, size: 16),
                          label:
                              const Text('View Saved JSON Data'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
