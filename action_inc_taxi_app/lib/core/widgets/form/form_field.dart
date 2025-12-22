import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:action_inc_taxi_app/core/constants/app_constants.dart';

class AppTextFormField extends StatelessWidget {
  final bool labelOnTop;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final TextAlign? textAlign;
  final bool isReadOnly;
  final void Function()? onTap;
  final int maxLines;

  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.textAlign,
    this.onTap,
    this.isReadOnly = false,
    this.labelOnTop = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      color: AppColors.textHint,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    const inputStyle = TextStyle(color: AppColors.textHint, fontSize: 14);
    const hintStyle = TextStyle(color: AppColors.textHint, fontSize: 14);
    if (labelOnTop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (labelText != null || hintText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                labelText ?? hintText ?? '',
                style: labelStyle,
                textAlign: TextAlign.left,
              ),
            ),
          TextFormField(
            maxLines: maxLines,
            onTap: onTap,
            readOnly: isReadOnly,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            onChanged: onChanged,
            enabled: enabled,
            textAlign: TextAlign.left,
            style: inputStyle,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              fillColor: AppColors.background,
              filled: true,
              prefixIcon: prefix,
              suffixIcon: suffix,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.inputBorderRadius,
                ),
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.inputBorderRadius,
                ),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.inputBorderRadius,
                ),
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (labelText != null)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  labelText!,
                  style: labelStyle,
                  textAlign: textAlign ?? TextAlign.center,
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: TextFormField(
              onTap: onTap,
              readOnly: isReadOnly,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              validator: validator,
              onChanged: onChanged,
              enabled: enabled,
              textAlign: TextAlign.left,
              style: inputStyle,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintStyle,
                errorText: errorText,
                fillColor: AppColors.background,
                filled: true,
                prefixIcon: prefix,
                suffixIcon: suffix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.inputBorderRadius,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.inputBorderRadius,
                  ),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.inputBorderRadius,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
