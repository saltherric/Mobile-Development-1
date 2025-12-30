// import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../widgets/category_card.dart';
import 'add_category_screen.dart';
// import '../../../data/repositories/saveluy_mock_repository.dart';
import '../../../data/repositories/saveluy_json_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final mockRepo = CategoryMockRepository();
  final jsonRepo = CategoryJsonRepository();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Call the JSON repo to read the local file 
    final loadedCategories = await jsonRepo.loadCategories();
    setState(() {
      categories = loadedCategories;
    });
  }

  void _navigateToAddCategory() async {
    // Navigating and waiting for the new category object back
    final newCategory = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCategoryScreen()),
    );

    if (newCategory != null && newCategory is Category) {
      setState(() {
        categories.add(newCategory);
      });
      // Tell the JSON repo to save the entire updated list to the device 
    await jsonRepo.saveCategories(categories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Setup'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories & Habits',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text('Manage your financial habit structure', 
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            
            // Add New Category Button [cite: 52]
            OutlinedButton.icon(
              onPressed: _navigateToAddCategory,
              icon: const Icon(Icons.add),
              label: const Text('Add New Category'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // List of Categories
            ...categories.map((cat) => CategoryCard(category: cat)),
            
            const SizedBox(height: 20),
            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                // ignore: deprecated_member_use
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Create categories that match your financial goals.'),
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