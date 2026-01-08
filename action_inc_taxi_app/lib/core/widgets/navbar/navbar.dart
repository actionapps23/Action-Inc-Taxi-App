// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/routes/app_routes.dart';
import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar_buttton.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/cubit/purchase/purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final LoginState loginState = loginCubit.state;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0xff191d19),
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
        children: [
          // Logo and title
          GestureDetector(
            onTap: () {
              // emit intial satte for all cubits
              context.read<SelectionCubit>().reset();
              context.read<DailyRentCubit>().reset();
              Navigator.of(context).pushReplacementNamed(AppRoutes.selection);
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
          SizedBox(width: 24.w),
          // Navigation buttons in the center (scrollable on mobile)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavButton(
                    'Dashboard',
                    icon: AppAssets.dashboard,
                    onTap: () {
                      context.read<SelectionCubit>().reset();
                      context.read<DailyRentCubit>().reset();
                      context.read<PurchaseCubit>().reset();
                      Navigator.pushNamed(context, AppRoutes.dashboard);
                    },
                  ),
                  SizedBox(width: 12.w),
                  NavButton(
                    'Reports',
                    icon: AppAssets.taxiInspection,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.report);
                    },
                  ),
                  if (loginState is LoginSuccess &&
                      loginState.user.isAdmin) ...[
                    SizedBox(width: 12.w),
                    NavButton(
                      'Add Employee',
                      icon: AppAssets.logout,
                      onTap: () {
                        context.read<SelectionCubit>().reset();
                        context.read<DailyRentCubit>().reset();
                        context.read<PurchaseCubit>().reset();
                        context.read<LoginCubit>().logout();
                      },
                    ),
                  ],
                  SizedBox(width: 12.w),
                  NavButton(
                    'Change Password',
                    icon: AppAssets.logout,
                    onTap: () {
                     
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.changePassword,
                        (route) => false,
                      );
                    },
                  ),
                   SizedBox(width: 12.w),
                  NavButton(
                    'Log out',
                    icon: AppAssets.logout,
                    onTap: () {
                      context.read<SelectionCubit>().reset();
                      loginCubit.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),
                  SizedBox(width: 24.w),
                ],
              ),
            ),
          ),
          // Avatar and name at the end
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppAssets.userAvatar),
                radius: 18,
              ),
              SizedBox(width: 4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (loginState is LoginSuccess)
                    ResponsiveText(
                      loginState.user.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  if (loginState is LoginSuccess)
                    ResponsiveText(
                      loginState.user.role,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
