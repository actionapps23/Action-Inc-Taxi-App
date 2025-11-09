import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showWarningSnackBar(
    BuildContext context,
    String text, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showTopSnackBar(
      context,
      text,
      const Icon(Icons.warning, color: AppColors.warningOutline),
      AppColors.warning,
      duration,
    );
  }

  static void showErrorSnackBar(
    BuildContext context,
    String errorMessage, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showTopSnackBar(
      context,
      errorMessage.contains("Exception:")
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage,
      Icon(Icons.error_outline, color: AppColors.errorOutline),
      AppColors.error,
      duration,
    );
  }

  static void showInfoSnackBar(
    BuildContext context,
    String text, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showTopSnackBar(
      context,
      text,
      const Icon(Icons.info, color: AppColors.infoOutline),
      AppColors.info,
      duration,
    );
  }

  static void showSuccessSnackBar(
    BuildContext context,
    String text, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showTopSnackBar(
      context,
      text,
      const Icon(Icons.done, color: AppColors.successOutline),
      AppColors.success,
      duration,
    );
  }

  static void showTopSnackBar(
    BuildContext context,
    String text,
    Icon icon,
    Color backgroudColor,
    Duration duration,
  ) {
    if (text.isNotEmpty) {
      final SnackBar snackBar = SnackBar(
        backgroundColor: backgroudColor,
        duration: duration,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon,
            Spacing.hStandard,
            Flexible(child: Text(text)),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static void showLoadingSnackBar(
    BuildContext context, [
    String message = "Loading ...",
  ]) {
    SnackBarHelper.showInfoSnackBar(context, message);
  }

  static void showGenericErrorMessage(BuildContext context) {
    SnackBarHelper.showErrorSnackBar(context, AppConstants.genericErrorMessage);
  }
}
