import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_isnpection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SectionWidget extends StatelessWidget {
  final SectionModel section;
  const SectionWidget({super.key, required this.section});
  @override
  Widget build(BuildContext context) {
    final VehicleInspectionPanelCubit vehicleInspectionPanelCubit = context
        .read<VehicleInspectionPanelCubit>();
    return BlocBuilder<
      VehicleInspectionPanelCubit,
      VehicleInspectionPanelState
    >(
      bloc: vehicleInspectionPanelCubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.sectionName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...section.fields.map(
                (field) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(field.fieldName),

                    Checkbox(
                      value: vehicleInspectionPanelCubit.isChecked(
                        field.fieldKey,
                      ),
                      onChanged: (value) {
                        vehicleInspectionPanelCubit.toggleField(field.fieldKey);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
