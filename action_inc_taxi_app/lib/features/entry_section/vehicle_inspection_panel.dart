import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/section_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInspectionPanel extends StatelessWidget {
  final String viewName;
  final List<SectionModel> sections;
  final String mapKey;
  const VehicleInspectionPanel({
    super.key,
    required this.viewName,
    required this.sections,
    required this.mapKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          children: [
            Navbar(),
            Spacing.vMedium,
            Center(
              child: Text(
                viewName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return SectionWidget(section: section);
                },
                itemCount: sections.length,
              ),
            ),
            ActionButtons(
              onSubmit: () {},
              onCancel: () {},
              submitButtonText: "Checked",
              cancelButtonText: "Back",
            ),
          ],
        ),
      ),
    );
  }
}
