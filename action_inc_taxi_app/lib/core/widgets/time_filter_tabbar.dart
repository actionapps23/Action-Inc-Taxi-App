import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';

class TimeFilterTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  const TimeFilterTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: const ['This week', 'Month', 'Year'],
      onTabSelected: onTabSelected,
      padding: const EdgeInsets.all(6),
      height: 36,
      borderRadius: 18,
    );
  }
}
