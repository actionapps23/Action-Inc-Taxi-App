import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
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
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius.w.clamp(6, 12)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.tabs.length, (index) {
            final bool isSelected = index == _selectedTab;
            return GestureDetector(
              onTap: () {
                widget.onTabSelected(index);
                setState(() {
                  _selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: widget.height.h.clamp(22, 30),
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 1.w,
                  right: index == widget.tabs.length - 1 ? 0 : 0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isSelected ? widget.selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius.w.clamp(6, 12),
                  ),
                ),
                alignment: Alignment.center,
                child: ResponsiveText(
                  widget.tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? widget.selectedTextColor
                        : widget.unselectedTextColor,
                    fontWeight: isSelected ? FontWeight.w400 : FontWeight.w200,
                    fontSize: 7.sp.clamp(6, 10),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
