import 'package:flutter/material.dart';

import '../../../models/category.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/common/common_widgets.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;

  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  late TextEditingController _nameController;
  late CategoryIcon _selectedIcon;
  late String _selectedColorName;

  final Map<String, Color> _colors = {
    'Green': AppColors.primary,
    'Blue': const Color(0xFF0D6EFD),
    'Red': const Color(0xFFFF6B6B),
    'Amber': const Color(0xFFFFC107),
    'Purple': const Color(0xFF9C27B0),
    'Cyan': const Color(0xFF00BCD4),
    'Orange': const Color(0xFFF57C00),
    'Pink': const Color(0xFFE91E63),
  };

  Color get _selectedColor =>
      _colors[_selectedColorName] ?? AppColors.primary;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.icon ?? CategoryIcon.other;

    // Find color name from hex
    if (widget.category != null) {
      final categoryColor = widget.category!.color;
      _selectedColorName = _colors.entries
              .firstWhere(
                (entry) => entry.value.value == categoryColor.value,
                orElse: () => _colors.entries.first,
              )
              .key;
    } else {
      _selectedColorName = 'Green';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    final category = Category(
      id: widget.category?.id,
      name: _nameController.text,
      icon: _selectedIcon,
      colorHex:
          '#${_selectedColor.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
    );

    Navigator.pop(context, category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // Using reusable AppBar
      appBar: AppAppBar(
        title: widget.category == null ? 'Create Category' : 'Edit Category',
        showBackButton: true,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using LabeledField + AppTextField
            LabeledField(
              label: 'Category Name',
              required: true,
              child: AppTextField(
                controller: _nameController,
                hintText: 'e.g., Food & Drink, Transportation',
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Using LabeledField + AppDropdown
            LabeledField(
              label: 'Select Icon',
              child: AppDropdown<CategoryIcon>(
                value: _selectedIcon,
                items: CategoryIcon.values,
                label: (icon) => icon.label,
                icon: (icon) => icon.icon,
                onChanged: (icon) => setState(() => _selectedIcon = icon),
                accentColor: _selectedColor,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Using LabeledField + ColorDropdown
            LabeledField(
              label: 'Select Color',
              child: ColorDropdown(
                selectedColorName: _selectedColorName,
                colors: _colors,
                onChanged: (name) => setState(() => _selectedColorName = name),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Preview section
            const FieldLabel(text: 'Preview'),
            const SizedBox(height: AppDimensions.paddingMedium),
            
            // Using ColoredCard for preview
            ColoredCard(
              color: _selectedColor,
              child: Row(
                children: [
                  // Using IconContainer
                  IconContainer(
                    icon: _selectedIcon.icon,
                    iconColor: _selectedColor,
                    backgroundColor: _selectedColor.withOpacity(0.2),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Text(
                      _nameController.text.isEmpty
                          ? 'Category Name'
                          : _nameController.text,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Using reusable buttons
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: PrimaryButton(
                    text: 'Save',
                    onPressed: _saveCategory,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
