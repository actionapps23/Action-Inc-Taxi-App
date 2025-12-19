import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/features/inventory/inventory_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventorySceen extends StatelessWidget {
  const InventorySceen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Navbar(),
            Spacing.vLarge,
            Container(
              margin: EdgeInsets.only(left: 12.w, right: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Inventory",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        CustomTabBar(
                          tabs: ["Engine", "Breaks", "Tires"],
                          selectedIndex: 0,
                          onTabSelected: (index) {},
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                        ),
                        Row(
                          children: [
                            AppOutlineButton(
                              borderColor: AppColors.scaffold,
                              label: "Enter inventory History",
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            SizedBox(width: 8),
                            AppOutlineButton(
                              prefixIcon: Icon(
                                Icons.history,
                                color: AppColors.scaffold,
                              ),
                              borderColor: AppColors.scaffold,
                              label: "History",
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacing.vLarge,
                    InventoryTable(),
                  ],
                ),
              ),
            ),
            Spacing.vXXLarge,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppOutlineButton(
                  label: "Back",
                  borderColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Update List",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Spacing.vXXLarge,
          ],
        ),
      ),
    );
  }
}
