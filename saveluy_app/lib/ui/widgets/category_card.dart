import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(category.type.icon, color: Colors.black), 
        ),
        title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(category.description),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}