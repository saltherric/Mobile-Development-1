import 'package:flutter/material.dart';

import 'analysis.dart';
import 'home.dart';
import 'settings/habit_form.dart';
import 'settings/habit_list.dart'; // This is your SettingsScreen
import 'add_record_screen.dart'; // The entry point for logging

class AppScreens extends StatefulWidget {
  const AppScreens({super.key});

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> {
  static const Color _primary = Color(0xFF20C997);
  int _currentIndex = 0;

  // We use AddRecordScreen here so the user can choose a category first
  final List<Widget> _pages = const [
    HomeScreen(),
    AddRecordScreen(), 
    AnalysisScreen(),
    SettingsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  /// This is the Floating "+" button logic
  Future<void> _onAddTap() async {
    // Navigates directly to the creation form
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HabitFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    // Index 0: Home
    // Index 1: Log (AddRecordScreen)
    // Index 2: Analysis
    // Index 3: Settings
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              _buildNavItem(
                Icons.home_outlined,
                'Home',
                _currentIndex == 0,
                () => _onTabSelected(0),
              ),
              _buildNavItem(
                Icons.playlist_add_check_outlined, // Changed icon to represent "Logging"
                'Log',
                _currentIndex == 1,
                () => _onTabSelected(1),
              ),
              _buildNavItem(
                Icons.add_circle, // The "Quick Create" button
                'Create',
                false,
                _onAddTap,
              ),
              _buildNavItem(
                Icons.bar_chart,
                'Analysis',
                _currentIndex == 2,
                () => _onTabSelected(2),
              ),
              _buildNavItem(
                Icons.settings_outlined,
                'Settings',
                _currentIndex == 3,
                () => _onTabSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback? onTap,
  ) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? _primary : Colors.grey,
                  size: 26,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11, // Slightly smaller to fit 5 items
                    color: isActive ? _primary : Colors.grey,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}