import 'package:flutter/material.dart';

class LogHabitScreen extends StatefulWidget {
  const LogHabitScreen({super.key});

  @override
  State<LogHabitScreen> createState() => _LogHabitScreenState();
}

class _LogHabitScreenState extends State<LogHabitScreen> {
  static const Color _primaryGreen = Color(0xFF20C997);
  static const Color _background = Color(0xFFF5F7FA);

  final List<HabitItem> _habits = <HabitItem>[
    HabitItem(
      title: 'Coffee Avoided',
      subtitle: 'No Coffee Today',
      streakDays: 3,
      asset: 'assets/images/coffee.png',
    ),
    HabitItem(
      title: 'Daily Savings Log',
      subtitle: 'Saved RM5 Today',
      streakDays: 5,
      asset: 'assets/images/pigBank.png',
    ),
    HabitItem(
      title: 'Impulse Buy Avoided',
      subtitle: 'Avoided Impulse Buy',
      streakDays: 7,
      asset: 'assets/images/onlineShopping.png',
    ),
    HabitItem(
      title: 'Home Cooked Meal',
      subtitle: 'Avoided Dining Out',
      streakDays: 2,
      asset: 'assets/images/homeCookMeal.png',
    ),
  ];

  int? _selectedIndex;
  bool _isHabitLogged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
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
      body: SafeArea(
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
              ...List.generate(_habits.length, (i) {
                final item = _habits[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HabitCard(
                    item: item,
                    isSelected: _selectedIndex == i,
                    isLogged: _isHabitLogged && _selectedIndex == i,
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
                          final selected = _habits[_selectedIndex!];
                          setState(() {
                            _isHabitLogged = true;
                            _selectedIndex = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✓ Logged: ${selected.title}'),
                              backgroundColor: _primaryGreen,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
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
      ),
    );
  }
}

class HabitItem {
  final String title;
  final String subtitle;
  final int streakDays;
  final String asset;

  const HabitItem({
    required this.title,
    required this.subtitle,
    required this.streakDays,
    required this.asset,
  });
}

class HabitCard extends StatefulWidget {
  final HabitItem item;
  final bool isSelected;
  final bool? isLogged;
  final VoidCallback onTap;
  final Color accentColor;

  const HabitCard({
    super.key,
    required this.item,
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
        transform: _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        child: Material(
          color: Colors.transparent,
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
                          color: widget.accentColor.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.title,
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
                          widget.item.subtitle,
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
                              '${widget.item.streakDays} day streak',
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

class _ImageThumb extends StatelessWidget {
  final String path;
  const _ImageThumb({required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 64,
        height: 64,
        color: Colors.grey.shade200,
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey.shade500,
              ),
            );
          },
        ),
      ),
    );
  }
}
