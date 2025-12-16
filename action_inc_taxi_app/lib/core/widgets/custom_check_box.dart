import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String label;

  const CustomCheckBox({required this.label, super.key});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.label),
        Checkbox(
          value: value,
          onChanged: (value) {
            setState(() {
              this.value = !this.value;
            });
          },
          checkColor: AppColors.primary,
        ),
      ],
    );
  }
}
