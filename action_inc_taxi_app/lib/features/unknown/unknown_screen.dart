import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceUtils = DeviceUtils(context);
    final double iconSize = deviceUtils.isExtraSmallMobile
        ? 60
        : deviceUtils.isSmallMobile
        ? 80
        : deviceUtils.isTablet
        ? 120
        : 100;
    final double horizontalPadding = deviceUtils.isExtraSmallMobile
        ? 12
        : deviceUtils.isSmallMobile
        ? 20
        : 32;
    final double titleFontSize = deviceUtils.isExtraSmallMobile
        ? 18
        : deviceUtils.isSmallMobile
        ? 22
        : deviceUtils.isTablet
        ? 32
        : 28;
    final double messageFontSize = deviceUtils.isExtraSmallMobile
        ? 12
        : deviceUtils.isSmallMobile
        ? 14
        : 16;
    final double buttonFontSize = deviceUtils.isExtraSmallMobile
        ? 14
        : deviceUtils.isSmallMobile
        ? 16
        : 18;
    final double buttonPaddingV = deviceUtils.isExtraSmallMobile ? 8 : 14;
    final double buttonPaddingH = deviceUtils.isExtraSmallMobile ? 16 : 32;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.help_outline,
                size: iconSize,
                color: AppColors.primary,
              ),
              SizedBox(height: iconSize * 0.32),
              ResponsiveText(
                'Oops! Unknown Screen',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ResponsiveText(
                'The page you are looking for does not exist or is currently unavailable.',
                style: TextStyle(
                  fontSize: messageFontSize,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: iconSize * 0.4),
              AppButton(
                text: 'Go Back',
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                minWidth: buttonPaddingH * 3,
                minHeight: buttonPaddingV * 2,
                textStyle: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonPaddingH,
                    vertical: buttonPaddingV,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
