import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/constants/app_constants.dart';

class AppDropdown<T> extends StatelessWidget {
  final String? labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final bool enabled;
  final bool labelOnTop;

  const AppDropdown({
    super.key,
    this.labelText,
    this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
    this.labelOnTop = false,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      color: AppColors.textHint,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    final dropdown = DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      dropdownColor: Colors.black,
      decoration: InputDecoration(
        hintText: 'Select Type',
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
    );

    if (labelOnTop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                labelText!,
                style: labelStyle,
              ),
            ),
          dropdown,
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (labelText != null)
            SizedBox(
              width: 110,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  labelText!,
                  style: labelStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          Expanded(
            child: dropdown,
          ),
        ],
      );
    }
  }
}
