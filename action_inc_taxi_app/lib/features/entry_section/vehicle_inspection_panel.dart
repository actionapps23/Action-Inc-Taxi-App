import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/section_widget.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:flutter/material.dart';

class VehicleInspectionPanel extends StatelessWidget {
  final String viewName;
  final List<SectionModel> sections;
  const VehicleInspectionPanel({
    super.key,
    required this.viewName,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          submitButtonText: "Next",
          cancelButtonText: "Back",
        ),
      ],
    );
  }
}
