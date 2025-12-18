// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NavButton extends StatelessWidget {
  final String label;
  final bool selected;
  final String? icon;
  final VoidCallback? onTap;

  const NavButton(
    this.label, {
    super.key,
    this.selected = false,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : Colors.white70,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        fontSize: 4.sp < 16 ? 12 : 4.sp,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Semantics(
          button: true,
          selected: selected,
          label: label,
          child: Row(
            children: [
              if (icon != null) SvgPicture.asset(icon!, height: 18),
              if (icon != null) const SizedBox(width: 6),
              text,
            ],
          ),
        ),
      ),
    );
  }
}
