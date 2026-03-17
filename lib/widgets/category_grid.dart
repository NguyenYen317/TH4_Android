import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  static const Map<String, IconData> _categoryIcons = {
    'electronics': Icons.devices,
    'jewelery': Icons.diamond,
    "men's clothing": Icons.man,
    "women's clothing": Icons.woman,
  };

  @override
  Widget build(BuildContext context) {
    final allCategories = ['Tất cả', ...categories];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isAll = index == 0;
          final isSelected = isAll
              ? selectedCategory == null
              : selectedCategory == category;
          final icon = _categoryIcons[category] ?? Icons.category;

          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isAll) ...[
                  Icon(icon, size: 14,
                      color: isSelected ? Colors.white : Colors.grey.shade700),
                  const SizedBox(width: 4),
                ],
                Text(
                  isAll ? 'Tất cả' : _capitalize(category),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            selected: isSelected,
            onSelected: (_) =>
                onCategorySelected(isAll ? null : category),
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          );
        },
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
