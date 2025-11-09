import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_text_form_field.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/widgets/feature_selection_card.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Navbar(),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: 320.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Select Options and Add Notes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Options',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        // Feature cards grid
                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 2.5,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            FeatureSelectionCard(
                              cardTitle: "Car Details",
                              iconPath: AppAssets.carDetailsIcon,
                              onTap: () {},
                            ),
                            FeatureSelectionCard(
                              cardTitle: "Maintenance",
                              iconPath: AppAssets.maintenance,
                              onTap: () {},
                            ),
                            FeatureSelectionCard(
                              cardTitle: "Inventory",
                              iconPath: AppAssets.inventory,
                              onTap: () {},
                            ),
                            FeatureSelectionCard(
                              cardTitle: "Taxi Inspection",
                              iconPath: AppAssets.taxiInspection,
                              onTap: () {},
                            ),
                            FeatureSelectionCard(
                              cardTitle: "Open Procedure",
                              iconPath: AppAssets.openProcedure,
                              onTap: () {},
                            ),
                            FeatureSelectionCard(
                              cardTitle: "Close Procedure",
                              iconPath: AppAssets.closeProcedure,
                              onTap: () {},
                            ),
                            FeatureSelectionCard(
                              cardTitle: "Renewal & Status",
                              iconPath: AppAssets.renewalStatus,
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        // Centered form
                        Center(
                          child: Container(
                            width: 180.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 32.h,
                              horizontal: 18.w,
                            ),
                            decoration: BoxDecoration(
                              // color: AppC,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Column(
                              children: [
                                // Text('Enter Taxi No.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(height: 18.h),
                                AppTextFormField(
                                  hintText: 'Enter Taxi No.',
                                  labelOnTop: true,
                                ),
                                SizedBox(height: 12.h),
                                // Text('or, Enter Taxi Registration No.', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  hintText: 'Taxi Registration No.',
                                  labelOnTop: true,
                                ),
                                SizedBox(height: 12.h),
                                // Text('or, Enter Driver Name', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  hintText: 'Driver Name',
                                  labelOnTop: true,
                                ),
                                SizedBox(height: 24.h),
                                AppButton(
                                  text: 'Enter',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CarDetailScreen(),
                                      ),
                                    );
                                  },
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  width: 90.w,
                                  height: 36.h,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
