import 'package:flutter/material.dart';
import '../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isSelected;      // Added to handle the selection state
  final VoidCallback onTap;   // Added to handle the tap event in the log screen
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isSelected, // Required for the Log Screen
    required this.onTap,      // Required for the Log Screen
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Triggers selection logic in LogHabitScreen
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // Changes border color based on selection
          border: Border.all(
            color: isSelected ? const Color(0xFF1BAB4F) : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon Section
              CircleAvatar(
                radius: 25,
                backgroundColor: isSelected 
                    ? const Color(0xFF1BAB4F).withOpacity(0.1) 
                    : Colors.grey.shade100,
                child: Icon(
                  habit.icon.iconData,
                  color: isSelected ? const Color(0xFF1BAB4F) : Colors.black87,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.quickLogText,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    // Optional: Shows the streak if you have that data
                    const Text(
                      "🔥 0 day streak",
                      style: TextStyle(
                        color: Colors.orange, 
                        fontSize: 12, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing Section (Selection Circle or Menu)
              if (onEdit != null || onDelete != null)
                _buildPopupMenu()
              else
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? const Color(0xFF1BAB4F) : Colors.grey.shade300,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Popup Menu for the Settings/List screen
  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') onEdit?.call();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }
}