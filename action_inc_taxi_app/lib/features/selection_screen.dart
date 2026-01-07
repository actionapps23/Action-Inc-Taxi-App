import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
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

  final taxiPlateNoController = TextEditingController();
  final taxiNoController = TextEditingController();
  final regNoController = TextEditingController();
  final driverNameController = TextEditingController();
  late final DeviceUtils deviceUtils;

  bool get isCarDetails => selectedIndex == 0;
  bool get isPurchase => selectedIndex == 8;

  bool get canProceed {
    if (isCarDetails) {
      return taxiNoController.text.trim().isNotEmpty &&
          regNoController.text.trim().isNotEmpty &&
          driverNameController.text.trim().isNotEmpty;
    } else {
      return taxiNoController.text.trim().isNotEmpty ||
          regNoController.text.trim().isNotEmpty ||
          taxiPlateNoController.text.trim().isNotEmpty;
    }
  }

  final List<Map<String, dynamic>> featureCards = [
     {'title': "Rent a Car", 'id': 'rent_a_car', 'icon': AppAssets.carDetailsIcon},
     {'title': "Car Details", 'id': 'car_details', 'icon': AppAssets.carDetailsIcon},
     {'title': "Maintenance", 'id': 'maintenance', 'icon': AppAssets.maintenance},
     {'title': "Inventory", 'id': 'inventory', 'icon': AppAssets.inventory},
     {'title': "Taxi Inspection", 'id': 'taxi_inspection', 'icon': AppAssets.taxiInspection},
     {'title': "Open Procedure", 'id': 'open_procedure', 'icon': AppAssets.openProcedure},
     {'title': "Close Procedure", 'id': 'close_procedure', 'icon': AppAssets.closeProcedure},
     {'title': "Renewal & Status", 'id': 'renewal_status', 'icon': AppAssets.renewalStatus},
     {'title': "Purchase of Car", 'id': 'car_purchase', 'icon': AppAssets.carPurchase},
     {'title': "Franchise Transfer", 'id': 'franchise_transfer', 'icon': AppAssets.franchiseTransfer},
     {'title': "Future Purchase", 'id': 'future_purchase', 'icon': AppAssets.futurePurchase},
  ];

  @override
  void dispose() {
    taxiNoController.dispose();
    regNoController.dispose();
    driverNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    deviceUtils = DeviceUtils(context);
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
                            ResponsiveText(
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
                          crossAxisCount:
                              deviceUtils.isExtraSmallMobile ||
                                  deviceUtils.isSmallMobile
                              ? 3
                              : 4,
                          shrinkWrap: true,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: HelperFunctions.getChildAspectRatio(
                            context,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(featureCards.length, (i) {
                            return FeatureSelectionCard(
                              cardTitle: featureCards[i]['title'],
                              iconPath: featureCards[i]['icon'],
                              backgroundColor: selectedIndex == i
                                  ? AppColors.primary
                                  : null,
                              onTap: () {
                                selectionCubit.proceed(
                                  i,
                                  context,
                                  featureCards[i]['id'],
                                );
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

                                if (isCarDetails) ...[
                                  AppTextFormField(
                                    controller: taxiNoController,
                                    hintText: 'Enter Taxi No.',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setTaxiNo(val);
                                    },
                                  ),
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
                                    hintText: 'Regular Driver Name',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setDriverName(val);
                                    },
                                  ),
                                ] else ...[
                                  SizedBox(height: 12.h),
                                  AppTextFormField(
                                    controller: taxiPlateNoController,
                                    hintText: 'Taxi Plate No.',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setTaxiPlateNo(val);
                                    },
                                  ),
                                  SizedBox(height: 12.h),

                                 if(!isPurchase)...[
                                   AppTextFormField(
                                    controller: taxiNoController,
                                    hintText: 'Enter Taxi No.',
                                    labelOnTop: true,
                                    onChanged: (val) {
                                      setState(() {});
                                      selectionCubit.setTaxiNo(val);
                                    },
                                  ),
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
                                 ]
                                ],
                                SizedBox(height: 24.h),
                                AppButton(
                                  text: 'Enter',
                                  onPressed: canProceed
                                      ? () {
                                          selectionCubit.proceed(
                                            selectedIndex,
                                            context,
                                            null,
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
