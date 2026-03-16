import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final itemWidth = 90.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isActive = category == selectedCategory;
          return SizedBox(
            width: itemWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => onCategorySelected(category),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF0096D6)
                          : const Color(0xFFE0E0E0),
                      width: isActive ? 2 : 1,
                    ),
                    color: isActive ? const Color(0xFFE0F7FF) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isActive
                            ? const Color(0xFF0096D6)
                            : const Color(0xFFF5F5F5),
                        child: Icon(
                          _iconForCategory(category),
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF666666),
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _displayCategory(category),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _displayCategory(String category) {
    switch (category) {
      case 'all':
        return 'Tất Cả';
      case "men's clothing":
        return 'Thời Trang Nam';
      case "women's clothing":
        return 'Thời Trang Nữ';
      case 'jewelery':
        return 'Phụ Kiện';
      case 'electronics':
        return 'Điện Tử';
      default:
        return category;
    }
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'all':
        return Icons.dashboard_rounded;
      case "men's clothing":
        return Icons.checkroom_rounded;
      case "women's clothing":
        return Icons.dry_cleaning_rounded;
      case 'jewelery':
        return Icons.diamond_outlined;
      case 'electronics':
        return Icons.devices_other_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
