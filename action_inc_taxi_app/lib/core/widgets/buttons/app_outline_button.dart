import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color borderColor;
  final Color textColor;
  final double fontSize;
  final Widget? prefixIcon;

  const AppOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderRadius = 16,
    this.padding,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.fontSize = 18,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveFontSize = fontSize;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        foregroundColor: textColor,
        backgroundColor: Colors.transparent,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 10)],
            Text(
              label,
              style: AppTextStyles.bodySmall
            ),
          ],
        ),
      ),
    );
  }
}
