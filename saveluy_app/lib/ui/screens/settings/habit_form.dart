import 'package:flutter/material.dart';
import '../../../models/habit.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? habit;

  const HabitFormScreen({super.key, this.habit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _nameController = TextEditingController();
  final _quickLogController = TextEditingController();

  IconType _selectedIcon = IconType.coffee;
  CategoryType _selectedCategory = CategoryType.saving;
  bool _showInQuickAdd = true;

  bool get _isEditing => widget.habit != null;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_isEditing ? 'Edit Habit' : 'Create Habit'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
              items: IconType.values,
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
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            _helper('Choose which category this habit belongs to'),
            const SizedBox(height: 20),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show in Quick Add'),
              subtitle:
                  const Text('Display this habit on the Add Record page'),
              value: _showInQuickAdd,
              activeColor: Colors.blue,
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
                  backgroundColor: const Color(0xFF81C784),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
        style: const TextStyle(fontWeight: FontWeight.w600),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Icon(icon(e)),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: Icon(_selectedIcon.iconData, color: Colors.green),
        ),
        title: Text(
          _nameController.text.isEmpty
              ? 'Habit Name'
              : _nameController.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _quickLogController.text.isEmpty
              ? 'Quick log text'
              : _quickLogController.text,
        ),
      ),
    );
  }
}
