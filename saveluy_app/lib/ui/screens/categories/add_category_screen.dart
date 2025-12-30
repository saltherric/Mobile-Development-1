import 'package:flutter/material.dart';
import '../../../models/category.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<AddCategoryScreen> {
  // Controllers for text fields 
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  
  // Default selection for the CategoryType enum
  CategoryType _selectedType = CategoryType.saving;

  void _onSave() {
    final name = _nameController.text.trim();
    final description = _descController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category Name is required *')),
      );
      return;
    }

    // Creating the Category object using  model logic
    final newCategory = Category(
      name: name,
      description: description.isEmpty ? 'No description' : description,
      type: _selectedType,
    );

    // Return the new category to the SettingsScreen 
    Navigator.pop(context, newCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add New Category", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Create a new financial habit category", 
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Category Name Field 
            const Text("Category Name *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "e.g., Saving & Investment Discipline",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Description Field 
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g., Habits related to consistent saving...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Icon/Type Selector 
            const Text("Category Type *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CategoryType>(
                  value: _selectedType,
                  isExpanded: true,
                  items: CategoryType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(type.icon, color: Colors.green),
                          const SizedBox(width: 12),
                          Text(type.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Buttons 
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF81C784), // SaveLuy Theme Green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save Category"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}