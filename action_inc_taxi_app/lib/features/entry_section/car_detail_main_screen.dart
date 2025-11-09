import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_dates_screen.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/features/entry_section/rent/daily_rent_collection_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({super.key});
  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  int selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    // Fetch car details using carId
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800.w),
              child: Column(
                children: [
                  const Navbar(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar (reusable)
                        SizedBox(height: 32.h),
                        // Section Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Car Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                                // Tabs
                                CustomTabBar(
                                  tabs: const [
                                    'Rental Information',
                                    // 'Car Plan',
                                    'Renewal Date',
                                  ],
                                  selectedIndex: selectedTabIndex,
                                  onTabSelected: (index) {
                                    setState(() {
                                      selectedTabIndex = index;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        if (selectedTabIndex == 0)
                          DailyRentCollectionInfoScreen(taxiNo: 'ABC-123'),
                        if (selectedTabIndex == 1)
                          RenewalDataTable(taxiNo: 'ABC-123'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
