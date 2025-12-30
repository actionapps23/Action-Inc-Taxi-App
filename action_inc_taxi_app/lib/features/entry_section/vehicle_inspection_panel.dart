import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/section_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_isnpection_state.dart';
import 'package:action_inc_taxi_app/features/inspection/vehicle_checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInspectionPanel extends StatefulWidget {
  final String viewName;
  final String mapKey;
  const VehicleInspectionPanel({
    super.key,
    required this.viewName,
    required this.mapKey,
  });

  @override
  State<VehicleInspectionPanel> createState() => _VehicleInspectionPanelState();
}

class _VehicleInspectionPanelState extends State<VehicleInspectionPanel> {
  @override
  void initState() {
    super.initState();
    final VehicleInspectionPanelCubit vehicleInspectionPanelCubit = context
        .read<VehicleInspectionPanelCubit>();
    vehicleInspectionPanelCubit.fetchSubmittedInspectionData('taxiID', widget.mapKey);
  }
  @override
  Widget build(BuildContext context) {
    final VehicleInspectionPanelCubit vehicleInspectionPanelCubit = context
        .read<VehicleInspectionPanelCubit>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          children: [
            Navbar(),
            Spacing.vMedium,
            Center(
              child: ResponsiveText(
                widget.viewName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            BlocBuilder<VehicleInspectionPanelCubit, VehicleInspectionPanelState>(
              bloc: vehicleInspectionPanelCubit,
              builder: (context, state) {
                if (state is VehicleInspectionPanelLoadingState) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is VehicleInspectionPanelErrorState) {
                  return Expanded(
                    child: Center(
                      child: ResponsiveText(
                        'Error: ${state.errorMessage}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final section = VehicleChecklist.rearViewSections[index];
                            return SectionWidget(category: section);
                          },
                          itemCount: VehicleChecklist.rearViewSections.length,
                        ),
                      ),
                      ActionButtons(
              onSubmit: () {
                final List<CategoryModel> selectedCategories = VehicleChecklist.rearViewSections
                    .map((category) {
                      List<FieldModel> fields = [];
                      for (FieldModel field in category.fields) {
                        fields.add(
                          field.copyWith(
                            isChecked: vehicleInspectionPanelCubit.isChecked(
                              field.fieldKey,
                            ),
                          ),
                        );
                      }

                      return CategoryModel(
                        categoryName: category.categoryName,
                        fields: fields,
                      );
                    })
                    .toList();
                vehicleInspectionPanelCubit.submitInspectionData(
                  'taxiID',
                  widget.mapKey,
                  selectedCategories,
                );
              },
              onCancel: () {},
              submitButtonText: "Checked",
              cancelButtonText: "Back",
            ),
                    ],
                  ),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
