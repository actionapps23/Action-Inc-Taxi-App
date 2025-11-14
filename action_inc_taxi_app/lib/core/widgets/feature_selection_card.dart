import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Widget iconWidget;
    if (iconPath.toLowerCase().endsWith('.svg')) {
      iconWidget = SvgPicture.asset(iconPath, height: 24, width: 24);
    } else {
      iconWidget = Image.asset(iconPath, height: 24, width: 24);
    }
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? AppColors.cardBackground,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget,
              SizedBox(width: 8),
              Flexible(
                child: Text(
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
