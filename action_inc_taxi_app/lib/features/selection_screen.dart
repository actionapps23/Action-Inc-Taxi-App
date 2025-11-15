import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_text_form_field.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/widgets/feature_selection_card.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  int selectedIndex = 0;

  final taxiNoController = TextEditingController();
  final regNoController = TextEditingController();
  final driverNameController = TextEditingController();

  bool get isCarDetails => selectedIndex == 0;

  bool get canProceed {
    if (isCarDetails) {
      return taxiNoController.text.trim().isNotEmpty &&
          regNoController.text.trim().isNotEmpty &&
          driverNameController.text.trim().isNotEmpty;
    } else {
      return taxiNoController.text.trim().isNotEmpty ||
          regNoController.text.trim().isNotEmpty;
    }
  }

  final List<Map<String, dynamic>> featureCards = [
    {'title': "Car Details", 'icon': AppAssets.carDetailsIcon},
    {'title': "Maintenance", 'icon': AppAssets.maintenance},
    {'title': "Inventory", 'icon': AppAssets.inventory},
    {'title': "Taxi Inspection", 'icon': AppAssets.taxiInspection},
    {'title': "Open Procedure", 'icon': AppAssets.openProcedure},
    {'title': "Close Procedure", 'icon': AppAssets.closeProcedure},
    {'title': "Renewal & Status", 'icon': AppAssets.renewalStatus},
  ];

  @override
  void dispose() {
    taxiNoController.dispose();
    regNoController.dispose();
    driverNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.read<SelectionCubit>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Navbar(),
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
                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 2.5,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(featureCards.length, (i) {
                            return FeatureSelectionCard(
                              cardTitle: featureCards[i]['title'],
                              iconPath: featureCards[i]['icon'],
                              backgroundColor: selectedIndex == i
                                  ? AppColors.primary
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedIndex = i;
                                });
                              },
                            );
                          }),
                        ),
                        SizedBox(height: 40.h),
                        Center(
                          child: Container(
                            width: 180.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 32.h,
                              horizontal: 18.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 18.h),
                                AppTextFormField(
                                  controller: taxiNoController,
                                  hintText: 'Enter Taxi No.',
                                  labelOnTop: true,
                                  onChanged: (val) {
                                    setState(() {});
                                    selectionCubit.setTaxiNo(val);
                                  },
                                ),
                                if (isCarDetails) ...[
                                  SizedBox(height: 12.h),
                                  AppTextFormField(
                                    controller: regNoController,
                                    hintText: 'Taxi Registration No.',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setRegNo(val);
                                    },
                                  ),
                                  SizedBox(height: 12.h),
                                  AppTextFormField(
                                    controller: driverNameController,
                                    hintText: 'Driver Name',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setDriverName(val);
                                    },
                                  ),
                                ] else ...[
                                  SizedBox(height: 12.h),
                                  AppTextFormField(
                                    controller: regNoController,
                                    hintText: 'Taxi Registration No.',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setRegNo(val);
                                    },
                                  ),
                                ],
                                SizedBox(height: 24.h),
                                AppButton(
                                  text: 'Enter',
                                  onPressed: canProceed
                                      ? () {
                                          selectionCubit.setAll(
                                            taxiNo: taxiNoController.text,
                                            regNo: regNoController.text,
                                            driverName:
                                                driverNameController.text,
                                          );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => CarDetailScreen(),
                                            ),
                                          );
                                        }
                                      : () {},
                                  backgroundColor: canProceed
                                      ? Colors.green
                                      : Colors.grey,
                                  textColor: Colors.white,
                                  width: 90.w,
                                  height: 36.h,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canProceed
                                        ? Colors.green
                                        : Colors.grey,
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
