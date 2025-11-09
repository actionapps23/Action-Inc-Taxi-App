// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar_buttton.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:action_inc_taxi_app/features/auth/login_screen.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_and_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
          Row(
            children: [
              // Logo (SVG or Image)
              SvgPicture.asset(AppAssets.logo, height: 32.h),
              SizedBox(width: 12.w),
              SvgPicture.asset(AppAssets.logoText, height: 24.h),
            ],
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const CarDetailScreen(),
                      ));
                    },
                  ),
                  SizedBox(width: 12.w),
                  NavButton('Renewal & Status', icon: AppAssets.entryList, onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RenewalAndStatusScreen(),
                    ));
                  }),
                  SizedBox(width: 12.w),
                  NavButton('Dashboard', icon: AppAssets.dashboard, onTap: () {
                    SnackBarHelper.showInfoSnackBar(context, 'Dashboard');
                  }),
                  SizedBox(width: 12.w),
                  NavButton('Log out', icon: AppAssets.logout, onTap: () {
                    // Simple logout: navigate back to login screen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }),
                  SizedBox(width: 12.w),
                  NavButton('Notification', icon: AppAssets.notifications, onTap: () {
                    SnackBarHelper.showInfoSnackBar(context, 'Notifications');
                  }),
                  SizedBox(width: 16.w),
                  // User avatar and name
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(AppAssets.userAvatar),
                        radius: 18,
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'David Smith',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Assistant',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
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
