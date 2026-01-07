import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // 1. Added UUID import
import '../../utils/database_helper.dart';
import '../../models/habit.dart';
import '../../models/dailyLog.dart'; // 2. Added DailyLog import
import '../widgets/habit_card.dart';

class LogHabitScreen extends StatefulWidget {
  const LogHabitScreen({super.key});

  @override
  State<LogHabitScreen> createState() => _LogHabitScreenState();
}

class _LogHabitScreenState extends State<LogHabitScreen> {
  String? _selectedHabitId;
  final _uuid = const Uuid(); // Define local uuid instance

  void _onLogHabitPressed() async {
    if (_selectedHabitId == null) return;

    // Create the log object
    final newLog = DailyLog(
      id: _uuid.v4(), 
      habitId: _selectedHabitId!,
      date: DateTime.now(),
    );

    // Save to DB using your helper
    await DatabaseHelper().insertDailyLog(newLog);

    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Habit logged!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back after success
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
        title: const Text("Log Habit",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              // Note: Ensure DatabaseHelper() uses the singleton/factory pattern you wrote
              future: DatabaseHelper().getQuickAddHabits(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final habits = snapshot.data ?? [];

                if (habits.isEmpty) {
                  return const Center(
                    child: Text(
                      "No habits added to Quick Add.\nUpdate them in Settings.",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return HabitCard(
                      habit: habit,
                      isSelected: _selectedHabitId == habit.id,
                      onTap: () => setState(() => _selectedHabitId = habit.id),
                    );
                  },
                );
              },
            ),
          ),
          // Bottom Log Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                // 4. Fixed: Connect the function to the button
                onPressed: _selectedHabitId == null ? null : _onLogHabitPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BAB4F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
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