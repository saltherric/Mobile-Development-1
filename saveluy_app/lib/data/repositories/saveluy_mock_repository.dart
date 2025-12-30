// ignore_for_file: file_names

import '../../models/category.dart';

class CategoryMockRepository {
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Saving & Investment',
      description: '3 habits',
      type: CategoryType.saving,
    ),       
    Category(
      id: '2',
      name: 'Avoidance & Reduction',
      description: '2 habits',
      type: CategoryType.avoidance,
    ),
  ];

  List<Category> getAll() {
    return _categories;
  }

  void add(Category category) {
    _categories.add(category);
  }

}
