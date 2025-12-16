import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_dates_screen.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/features/entry_section/rent/daily_rent_collection_info_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/car_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_cubit.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_state.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({super.key});
  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Provide the cubit at screen level so children can read/update selected tab
    return BlocProvider(
      create: (_) => CarDetailCubit(),
      child: SafeArea(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  BlocBuilder<CarDetailCubit, CarDetailState>(
                                    builder: (context, state) {
                                      final selectedIndex =
                                          state is CarDetailLoaded
                                          ? state.selectedIndex
                                          : 0;
                                      return CustomTabBar(
                                        tabs: const [
                                          'Rental Information',
                                          'Car Plan',
                                          'Renewal Date',
                                        ],
                                        selectedIndex: selectedIndex,
                                        onTabSelected: (index) {
                                          // Allow free switching between all tabs (0, 1, and 2)
                                          context
                                              .read<CarDetailCubit>()
                                              .selectTab(index);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          BlocBuilder<CarDetailCubit, CarDetailState>(
                            builder: (context, state) {
                              final selectedIndex = state is CarDetailLoaded
                                  ? state.selectedIndex
                                  : 0;
                              if (selectedIndex == 0) {
                                return DailyRentCollectionInfoScreen();
                              } else if (selectedIndex == 1) {
                                return CarPlanScreen();
                              }
                              return RenewalDataTable();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
