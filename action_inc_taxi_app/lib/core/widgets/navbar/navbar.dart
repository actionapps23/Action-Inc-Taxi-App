// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar_buttton.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/auth/add_employee_screen/add_employee_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:action_inc_taxi_app/features/auth/login_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_and_status_screen.dart';
import 'package:action_inc_taxi_app/features/maintainence/maintainence_screen.dart';
import 'package:action_inc_taxi_app/features/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final LoginSuccess loginState = loginCubit.state as LoginSuccess;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and title
          GestureDetector(
            onTap: () {
              // emit intial satte for all cubits
              context.read<SelectionCubit>().reset();
              context.read<DailyRentCubit>().reset();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SelectionScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.logoPNG,
                  width: 64.w,
                  height: 48.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          // Navigation - make this horizontally scrollable so it doesn't overflow
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  NavButton(
                    'Entry Section',
                    selected: true,
                    icon: AppAssets.entrySection,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CarDetailScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  NavButton(
                    'Renewal & Status',
                    selected: true,
                    icon: AppAssets.entryList,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => RenewalAndStatusScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  NavButton(
                    'Dashboard',
                    icon: AppAssets.dashboard,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaintainenceScreen(),
                        ),
                      );
                    },
                  ),
                  if(loginState.user.isAdmin)...[
                    SizedBox(width: 12.w),
                    NavButton(
                      'Add Employee',
                      icon: AppAssets.logout,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEmployeeScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                 
                  SizedBox(width: 12.w),
                  NavButton(
                    'Log out',
                    icon: AppAssets.logout,
                    onTap: () {
                      // Simple logout: navigate back to login screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  SizedBox(width: 24.w),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(AppAssets.userAvatar),
                        radius: 18,
                      ),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loginState.user.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            loginState.user.role,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
