import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedTextColor;
  final Color selectedTextColor;
  final double height;
  final double borderRadius;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor = const Color(0xFF181A17),
    this.selectedColor = AppColors.primary,
    this.unselectedTextColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.height = 24,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: height,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 8,
                right: index == tabs.length - 1 ? 0 : 0,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.w400 : FontWeight.w200,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
