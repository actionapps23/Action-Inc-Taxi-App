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

  const AppOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderRadius = 12,
    this.padding,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final double minWidth = 10.w;
    final double effectiveFontSize = 5.sp;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          foregroundColor: textColor,
          backgroundColor: Colors.transparent,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: effectiveFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
