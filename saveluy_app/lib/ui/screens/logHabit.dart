import 'package:flutter/material.dart';

import '../../data/repositories/habitRepository.dart';
import '../../models/dailyLog.dart';
import '../../models/habit.dart';
import '../../utils/databaseHelper.dart';

class LogHabitScreen extends StatefulWidget {
  const LogHabitScreen({super.key});

  @override
  State<LogHabitScreen> createState() => _LogHabitScreenState();
}

class _LogHabitScreenState extends State<LogHabitScreen> {
  static const Color _primaryGreen = Color(0xFF20C997);
  static const Color _background = Color(0xFFF5F7FA);

  late HabitRepository _habitRepository;
  late DatabaseHelper _database;
  late Future<List<Habit>> _habitsFuture;

  int? _selectedIndex;
  // Track which habit IDs have been logged today
  final Set<String> _loggedHabitIds = <String>{};

  @override
  void initState() {
    super.initState();
    _habitRepository = HabitRepository();
    _database = DatabaseHelper();
    _habitsFuture = _loadHabits();
  }

  Future<List<Habit>> _loadHabits() async {
    final habits = await _habitRepository.getAllHabits();

    // Load today's logged habits
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    for (final habit in habits) {
      final logs = await _database.getDailyLogs(habit.id);
      for (final log in logs) {
        final logDate = DateTime.parse(log['date'] as String);
        final logDateOnly = DateTime(logDate.year, logDate.month, logDate.day);
        if (logDateOnly == todayStart) {
          _loggedHabitIds.add(habit.id);
          break;
        }
      }
    }

    return habits;
  }

  void _logHabit(Habit habit) {
    // Insert daily log entry
    final dailyLog = DailyLog(habitId: habit.id, date: DateTime.now());
    _database.insertDailyLog(dailyLog.toMap());

    setState(() {
      _loggedHabitIds.add(habit.id);
      _selectedIndex = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ Logged: ${habit.name}'),
        backgroundColor: _primaryGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Log Habit',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading habits'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _habitsFuture = _loadHabits();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final habits = snapshot.data ?? [];
          if (habits.isEmpty) {
            return const Center(
              child: Text('No habits found. Create one in Settings.'),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What did you do today?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(habits.length, (i) {
                    final habit = habits[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HabitCard(
                        habit: habit,
                        isSelected: _selectedIndex == i,
                        isLogged: _loggedHabitIds.contains(habit.id),
                        onTap: () => setState(() => _selectedIndex = i),
                        accentColor: _primaryGreen,
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selectedIndex == null
                          ? null
                          : () {
                              final habit = habits[_selectedIndex!];
                              _logHabit(habit);
                            },
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: const Text(
                        'Log Habit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HabitCard extends StatefulWidget {
  final Habit habit;
  final bool isSelected;
  final bool? isLogged;
  final VoidCallback onTap;
  final Color accentColor;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isSelected,
    this.isLogged = false,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isSelected
        ? widget.accentColor
        : (widget.isLogged ?? false)
        ? widget.accentColor.withOpacity(0.5)
        : const Color(0xFFE0E0E0);

    final backgroundColor = (widget.isLogged ?? false)
        ? widget.accentColor.withOpacity(0.05)
        : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: (widget.isLogged ?? false) ? null : widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: widget.isSelected ? 2 : 1,
                ),
                color: backgroundColor,
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: widget.accentColor.withOpacity(0.18),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _IconThumb(icon: widget.habit.icon.iconData),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.habit.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: (widget.isLogged ?? false)
                                      ? Colors.black54
                                      : Colors.black87,
                                  decoration: (widget.isLogged ?? false)
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.accentColor,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            else if (widget.isLogged ?? false)
                              Icon(
                                Icons.check_circle,
                                color: widget.accentColor,
                                size: 24,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.habit.quickLogText,
                          style: TextStyle(
                            fontSize: 13,
                            color: (widget.isLogged ?? false)
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.habit.type.label,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconThumb extends StatelessWidget {
  final IconData icon;
  const _IconThumb({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 64,
        height: 64,
        color: Colors.grey.shade200,
        child: Icon(icon, size: 32, color: Colors.grey.shade600),
      ),
    );
  }
}
