import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventorySceen extends StatelessWidget{
  InventorySceen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(),
          Spacing.vLarge,
          Container(
            margin: EdgeInsets.only(left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Invenotory"),
                    CustomTabBar(tabs: [
                      "Engine",
                      "Brakes",
                      "Tires",
                    ], selectedIndex: 0, onTabSelected: (index){}),
                    AppOutlineButton(
                      borderColor: AppColors.scaffold,
                      label: "History",
                    )
                    
                  ],
                )
              ],
            ),
          )
          
        ],
      ),
    );
  }

}