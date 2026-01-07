import 'package:flutter/material.dart';
import '../../../models/habit.dart';
import '../../../data/habit_repository.dart';
import '../../widgets/habit_card.dart';
import 'habit_form.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final HabitRepository _repo = HabitRepository();

  List<Habit> habits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    final data = await _repo.getAllHabits();
    if (!mounted) return;
    setState(() {
      habits = data;
      isLoading = false;
    });
  } 

  void _delete(BuildContext context, Habit habit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete habit'),
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

    await _repo.deleteHabit(habit.id);
    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habit deleted'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Navigate to Add Habit screen
  Future<void> _navigateToAddHabit() async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (_) => const HabitFormScreen(),
      ),
    );

    if (result == null) return;

    await _repo.addHabit(result);
    await _load();

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

    await _repo.updateHabit(result);
    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habit updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
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
              'Habits',
              style:
              TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your financial habit structure',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// Add Habit Button
            OutlinedButton.icon(
              onPressed: _navigateToAddHabit,
              icon: const Icon(Icons.add),
              label: const Text('Add New Habit'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Habit List
            if (habits.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No habits yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...habits.map(
                    (habit) => HabitCard(
                  habit: habit,
                  onEdit: () => _navigateToEditHabit(habit),
                  onDelete: () => _delete(context, habit),
                ),
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
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Create habits that match your financial goals.',
                    ),
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
