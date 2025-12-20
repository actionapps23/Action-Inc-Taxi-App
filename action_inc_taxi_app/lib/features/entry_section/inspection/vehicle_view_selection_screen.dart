// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:action_inc_taxi_app/features/entry_section/inspection/view_selection_grid.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_panel.dart';
import 'package:action_inc_taxi_app/features/inspection/vehicle_checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleViewSelectionScreen extends StatelessWidget {
  const VehicleViewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
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
                    // initialValue: selectionCubit.state.taxiNo,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: AppTextFormField(
                    isReadOnly: true,
                    // initialValue: selectionCubit.state.regNo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Flexible(
              child: ViewSelectionGrid(
                selectedIndex: selectedIndex,
                onTapIndex: (index) {
                  selectedIndex = index;
                },
              ),
            ),
            SizedBox(height: 24),
            ActionButtons(
              onSubmit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleInspectionPanel(
                      viewName: _viewName[selectedIndex],
                      sections: _viewSections[selectedIndex],
                      mapKey: _keys[selectedIndex],
                    ),
                  ),
                );
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

const List<String> _viewName = [
  "Front View",
  "Rear View",
  "Top View",
  "Bottom View",
  "Left View",
  "Right View",
  "Mechanical Part",
  "Interior",
];

const List<String> _keys = [
  "front_view",
  "rear_view",
  "top_view",
  "bottom_view",
  "left_view",
  "right_view",
  "mechanical_part",
  "interior",
];

const List<List<SectionModel>> _viewSections = [
  VehicleChecklist.frontViewSections,
  VehicleChecklist.rearViewSections,
  VehicleChecklist.topViewSections,
  VehicleChecklist.bottomViewSections,
  VehicleChecklist.leftSideSections,
  VehicleChecklist.rightSideSections,
  VehicleChecklist.mechanicalSections,
  VehicleChecklist.interiorSections,
];

// ignore: non_constant_identifier_names
