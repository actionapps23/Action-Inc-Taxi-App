import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_state.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_dates_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/rent/daily_rent_collection_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_cubit.dart';

class CarDetailScreen extends StatefulWidget {
  final bool fetchDetails;
  const CarDetailScreen({super.key, this.fetchDetails = false});
  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.fetchDetails) {
      final CarDetailCubit carDetailCubit = context.read<CarDetailCubit>();
      final SelectionCubit selectionCubit = context.read<SelectionCubit>();
      final String taxiNo = selectionCubit.state.taxiNo;
      final String regNo = selectionCubit.state.regNo;
      final String taxiPlateNo = selectionCubit.state.taxiPlateNo;
      carDetailCubit.loadCarDetails(taxiNo, regNo, taxiPlateNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CarDetailCubit carDetailCubit = context.read<CarDetailCubit>();
    return BlocBuilder<CarDetailCubit, CarDetailState>(
      bloc: carDetailCubit,
      builder: (context, state) {
        if (state is CarDetailNotFound) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Navbar(),
                    SizedBox(height: 32.h),
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(height: 16.h),
                    const ResponsiveText(
                      'No car details found.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is CarDetailError) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Navbar(),
                    SizedBox(height: 32.h),
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    SizedBox(height: 16.h),
                    ResponsiveText(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is CarDetailLoaded || !widget.fetchDetails) {
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
                              SizedBox(height: 32.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ResponsiveText(
                                        'Car Details',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                      if (!widget.fetchDetails) ...[
                                        CustomTabBar(
                                          tabs: [
                                            'Rental Information',
                                            'Renewal Date',
                                          ],
                                          onTabSelected: (int index) {},
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              if (carDetailCubit.state.selectedIndex == 0) ...[
                                SizedBox(height: 24.h),
                                DailyRentCollectionInfoScreen(
                                  fetchDetails: widget.fetchDetails,
                                ),
                              ] else if (carDetailCubit.state.selectedIndex ==
                                  1) ...[
                                SizedBox(height: 24.h),
                                RenewalDataTable(),
                              ],
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
        return const SizedBox.shrink();
      },
    );
  }
}
