import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

class FeatureSelectionCard extends StatelessWidget {
  final String cardTitle;
  final String iconPath;
  final VoidCallback onTap;

  final Color? backgroundColor;

  const FeatureSelectionCard({
    super.key,
    required this.cardTitle,
    required this.iconPath,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final deviceUtils = DeviceUtils(context);

    // Responsive icon size and layout
    final iconSize = deviceUtils.isSmallMobile || deviceUtils.isExtraSmallMobile
        ? 16.0
        : 20.0;
    final useVerticalLayout = deviceUtils.isSmallMobile;

    Widget iconWidget;
    if (iconPath.toLowerCase().endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        height: iconSize,
        width: iconSize,
      );
    } else {
      iconWidget = Image.asset(iconPath, height: iconSize, width: iconSize);
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? AppColors.cardBackground,
        child: Center(
          child: useVerticalLayout
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    iconWidget,
                    const SizedBox(height: 6),
                    Flexible(
                      child: ResponsiveText(
                        cardTitle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: AppColors.scaffold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: iconWidget),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ResponsiveText(
                        cardTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.scaffold),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
