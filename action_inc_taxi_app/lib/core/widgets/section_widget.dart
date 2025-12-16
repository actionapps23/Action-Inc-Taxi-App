import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final SectionModel section;
  const SectionWidget({super.key, required this.section});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          section.sectionName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...section.fields
            .map(
              (field) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(field.fieldName),

                  Checkbox(value: field.isChecked, onChanged: (value) {}),
                ],
              ),
            )
            .toList(),
      ],
    );
  }
}
