import 'package:flutter/material.dart';
import '../../../models/habit.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? habit;

  const HabitFormScreen({super.key, this.habit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  static const Color _primaryGreen = Color(0xFF20C997);
  static const Color _background = Color(0xFFF5F7FA);
  final _nameController = TextEditingController();
  final _quickLogController = TextEditingController();

  IconType _selectedIcon = IconType.coffee;
  CategoryType _selectedCategory = CategoryType.saving;
  bool _showInQuickAdd = true;

  bool get _isEditing => widget.habit != null;

  List<IconType> _iconsForCategory(CategoryType category) {
    switch (category) {
      case CategoryType.saving:
        return [
          IconType.piggyBank,
          IconType.wallet,
          IconType.cash,
          IconType.growth,
          IconType.bank,
        ];
      case CategoryType.investment:
        return [
          IconType.growth,
          IconType.bank,
          IconType.wallet,
        ];
      case CategoryType.debt:
        return [
          IconType.cutCard,
          IconType.cash,
          IconType.bank,
        ];
      case CategoryType.avoidance:
        return [
          IconType.coffee,
          IconType.shoppingCart,
          IconType.noSpending,
          IconType.block,
        ];
      case CategoryType.other:
        return [
          IconType.other,
          IconType.home,
          IconType.gym,
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    final h = widget.habit;
    if (h != null) {
      _nameController.text = h.name;
      _quickLogController.text = h.quickLogText;
      _selectedIcon = h.icon;
      _selectedCategory = h.type;
      _showInQuickAdd = h.showInQuickAdd;
    }
    // Ensure the initially selected icon is valid for the category
    final choices = _iconsForCategory(_selectedCategory);
    if (!choices.contains(_selectedIcon)) {
      _selectedIcon = choices.first;
    }
  }

  void _onSave() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit Name is required')),
      );
      return;
    }

    final newHabit = Habit(
      id: widget.habit?.id,
      name: _nameController.text.trim(),
      quickLogText: _quickLogController.text.trim(),
      icon: _selectedIcon,
      showInQuickAdd: _showInQuickAdd,
      type: _selectedCategory,
    );

    Navigator.pop(context, newHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(_isEditing ? 'Edit Habit' : 'Create Habit',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Habit Name'),
            _input(
              controller: _nameController,
              hint: 'e.g., Coffee Avoided, Daily Savings',
            ),
            _helper('Give your habit a clear, memorable name'),

            const SizedBox(height: 20),

            _label('Quick Log Text'),
            _input(
              controller: _quickLogController,
              hint: 'e.g., No Coffee Today, Saved RM5',
            ),
            _helper('This text appears on the quick-add card'),

            const SizedBox(height: 20),

            _label('Select Icon'),
            _dropdown<IconType>(
              value: _selectedIcon,
              items: _iconsForCategory(_selectedCategory),
              label: (i) => i.label,
              icon: (i) => i.iconData,
              onChanged: (v) => setState(() => _selectedIcon = v),
            ),

            const SizedBox(height: 20),

            _label('Category'),
            _dropdown<CategoryType>(
              value: _selectedCategory,
              items: CategoryType.values,
              label: (c) => c.label,
              icon: (c) => c.icon,
              onChanged: (v) => setState(() {
                _selectedCategory = v;
                final choices = _iconsForCategory(_selectedCategory);
                if (!choices.contains(_selectedIcon)) {
                  _selectedIcon = choices.first;
                }
              }),
            ),
            _helper('Choose which category this habit belongs to'),
            const SizedBox(height: 20),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show in Quick Add'),
              subtitle:
                  const Text('Display this habit on the Add Record page'),
              value: _showInQuickAdd,
              activeColor: _primaryGreen,
              onChanged: (v) => setState(() => _showInQuickAdd = v),
            ),

            const SizedBox(height: 24),

            /// Preview
            _label('Preview'),
            const SizedBox(height: 8),
            _previewCard(),
          ],
        ),
      ),

      /// Bottom Buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- UI Helpers ----------------

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );

  Widget _helper(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(text,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      );

  Widget _input({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) label,
    required IconData Function(T) icon,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(icon(e), color: _primaryGreen, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(label(e)),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }

  Widget _previewCard() {
    return Container(
      decoration: BoxDecoration(
        color: _primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_selectedIcon.iconData, color: _primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text.isEmpty ? 'Habit Name' : _nameController.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _quickLogController.text.isEmpty ? 'Quick log text' : _quickLogController.text,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
