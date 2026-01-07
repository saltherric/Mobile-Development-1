import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../utils/database_helper.dart';
import '../../models/habit.dart';
import '../../models/dailyLog.dart';
import '../widgets/habit_card.dart';

class LogHabitScreen extends StatefulWidget {
  final CategoryType selectedCategory; // Pass category from AddRecordScreen

  const LogHabitScreen({super.key, required this.selectedCategory});

  @override
  State<LogHabitScreen> createState() => _LogHabitScreenState();
}

class _LogHabitScreenState extends State<LogHabitScreen> {
  // --- UNCOMMENTED THESE ---
  String? _selectedHabitId;
  final _uuid = const Uuid();

  void _onLogHabitPressed() async {
    if (_selectedHabitId == null) return;

    final newLog = DailyLog(
      id: _uuid.v4(),
      habitId: _selectedHabitId!,
      date: DateTime.now(),
    );

    // Using DatabaseHelper singleton
    await DatabaseHelper().insertDailyLog(newLog);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Habit logged!'),
          backgroundColor: Color(0xFF1BAB4F),
        ),
      );
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${widget.selectedCategory.label} Habits",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "What did you do today?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Habit>>(
              // Filtering by category as requested
              future: DatabaseHelper().getHabitsByCategory(widget.selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final habits = snapshot.data ?? [];
                if (habits.isEmpty) {
                  return const Center(child: Text("No habits found in this category."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return HabitCard(
                      habit: habit,
                      isSelected: _selectedHabitId == habit.id, // Now defined!
                      onTap: () => setState(() => _selectedHabitId = habit.id), // Now defined!
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _selectedHabitId == null ? null : _onLogHabitPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BAB4F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Log Habit",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}