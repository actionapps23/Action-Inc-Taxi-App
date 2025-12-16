// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleViewSelectionScreen extends StatelessWidget {
  const VehicleViewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectionCubit selectionCubit = context.read<SelectionCubit>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Navbar(),
            SizedBox(height: 24.h),
            Row(
              children: [
                Flexible(
                  child: AppTextFormField(
                    isReadOnly: true,
                    initialValue: "selectionCubit.state.taxiNo",
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: AppTextFormField(
                    isReadOnly: true,
                    initialValue: "selectionCubit.state.regNo",
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // The grid should expand to fill available space
            Flexible(child: ViewSelectionGrid()),
            SizedBox(height: 24),
            ActionButtons(
              onSubmit: () {
                Navigator.pop(context);
              },
              onCancel: () {
                Navigator.pop(context);
              },
              submitButtonText: "Next",
              cancelButtonText: "Back",
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget ViewSelectionGrid() {
  final List<Map<String, String>> views = [
    {"asset": AppAssets.frontView, "label": "Front View"},
    {"asset": AppAssets.rearView, "label": "Rear View"},
    {"asset": AppAssets.topView, "label": "Top View"},
    {"asset": AppAssets.bottomView, "label": "Bottom View"},
    {"asset": AppAssets.leftView, "label": "Left View"},
    {"asset": AppAssets.rightView, "label": "Right View"},
    {"asset": AppAssets.mechanicalPart, "label": "Mechanical Part"},
    {"asset": AppAssets.interior, "label": "Interior"},
  ];
  return GridView.count(
    crossAxisCount: 4,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 1.75,
    children: List.generate(views.length, (index) {
      final asset = views[index]["asset"]!;
      final label = views[index]["label"]!;
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181917),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(asset, width: 120, height: 80, fit: BoxFit.contain),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }),
  );
}
