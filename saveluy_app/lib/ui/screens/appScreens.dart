import 'package:flutter/material.dart';

import 'analysis.dart';
import 'home.dart';
import 'logHabit.dart';
import 'settings/settingsMain.dart';

class AppScreens extends StatefulWidget {
  const AppScreens({super.key});

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> {
  static const Color _primary = Color(0xFF20C997);
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LogHabitScreen(),
    AnalysisScreen(),
    SettingsMainScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    final bool isHome = _currentIndex == 0;
    final bool isLog = _currentIndex == 1;
    final bool isAnalysis = _currentIndex == 2;
    final bool isSettings = _currentIndex == 3;

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
                isHome,
                () => _onTabSelected(0),
              ),
              _buildNavItem(
                Icons.add_circle_outline,
                'Log',
                isLog,
                () => _onTabSelected(1),
              ),
              _buildNavItem(
                Icons.bar_chart,
                'Analysis',
                isAnalysis,
                () => _onTabSelected(2),
              ),
              _buildNavItem(
                Icons.settings_outlined,
                'Settings',
                isSettings,
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
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          hoverColor: _primary.withOpacity(0.08),
          splashColor: _primary.withOpacity(0.12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: isActive ? _primary : Colors.grey, size: 26),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
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
