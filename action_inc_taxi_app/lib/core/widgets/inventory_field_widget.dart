import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:flutter/material.dart';

class InventoryField extends StatelessWidget {
  final String label;
  final Widget child;

  const InventoryField({required this.label, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyExtraSmall.copyWith(color: Colors.white),
            softWrap: true,
          ),
        ),
        Spacing.hStandard,
        Flexible(flex: 2, child: child),
        Spacing.vStandard,
      ],
    );
  }
}
