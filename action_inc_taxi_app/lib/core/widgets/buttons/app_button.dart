import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.style,
    this.textStyle,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.buttonPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    );

    final ButtonStyle finalStyle = style ?? defaultStyle;

    final Widget content = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : ResponsiveText(
            text,
            style:
                textStyle ??
                TextStyle(
                  fontSize: AppConstants.fontSizeButton,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColors.buttonText,
                ),
          );

    final Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: finalStyle,
      child: content,
    );

    final constraints = BoxConstraints(
      minWidth: minWidth ?? 0,
      minHeight: minHeight ?? 0,
      maxWidth: maxWidth ?? double.infinity,
      maxHeight: maxHeight ?? double.infinity,
    );

    final constrained = ConstrainedBox(constraints: constraints, child: button);

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: constrained);
    }

    return constrained;
  }
}
