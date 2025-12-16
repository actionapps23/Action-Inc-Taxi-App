import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final String submitButtonText;
  final String cancelButtonText;
  const ActionButtons({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    this.submitButtonText = 'Submit Now',
    this.cancelButtonText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          text: cancelButtonText,
          onPressed: onCancel,
          backgroundColor: AppColors.cardBackground,
          textColor: Colors.white,
          width: 100.w,
          height: 44.h,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.white12),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        AppButton(
          text: submitButtonText,
          onPressed: onSubmit,
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          width: 120.w,
          height: 44.h,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
