import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/add_procedure_field_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/section_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_isnpection_state.dart';
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
  late VehicleInspectionPanelCubit vehicleInspectionPanelCubit;
  late SelectionCubit selectionCubit;
  @override
  void initState() {
    super.initState();
    vehicleInspectionPanelCubit = context.read<VehicleInspectionPanelCubit>();
    selectionCubit = context.read<SelectionCubit>();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          children: [
            Navbar(),
            Spacing.vMedium,

            BlocBuilder<
              VehicleInspectionPanelCubit,
              VehicleInspectionPanelState
            >(
              bloc: vehicleInspectionPanelCubit,
              builder: (context, state) {
                if (state is VehicleInspectionChecklistLoading ||
                    state is VehicleInspectionDataLoading) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is VehicleInspectionDataError ||
                    state is VehicleIsnpectionChecklistError) {
                  return Expanded(
                    child: Center(
                      child: ResponsiveText(
                        'Error: ${AppConstants.genericErrorMessage}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ResponsiveText(
                              widget.viewName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          AppOutlineButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddProcedureFieldPopup(
                                  sections: state.inspectionChecklistFromDB!
                                      .map((e) => e.categoryName)
                                      .toList(),
                                  procedureType: widget.viewName,
                                  onSubmit:
                                      ({
                                        required sectionName,
                                        required fieldName,
                                      }) {
                                        vehicleInspectionPanelCubit
                                            .updateInspectionChecklist(
                                              view: widget.mapKey,
                                              category: CategoryModel(
                                                categoryName: sectionName,
                                                fields: [
                                                  FieldModel(
                                                    fieldName: fieldName,
                                                    fieldKey:
                                                        HelperFunctions.getKeyFromTitle(
                                                          fieldName,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            );
                                      },
                                ),
                              );
                            },
                            label: "Add new field",
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final category =
                                state.inspectionChecklistFromDB![index];
                            return SectionWidget(
                              category: category,
                              mapKey: widget.mapKey,
                            );
                          },
                          itemCount: state.inspectionChecklistFromDB!.length,
                        ),
                      ),
                      ActionButtons(
                        onSubmit: () {
                          vehicleInspectionPanelCubit.submitInspectionData(
                            selectionCubit.state.taxiPlateNo,
                            widget.mapKey,
                          );
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
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

  Future<void> refreshData() async {
    if (vehicleInspectionPanelCubit.state is! VehicleInspectionDataLoaded ||
        (vehicleInspectionPanelCubit.state is VehicleInspectionDataLoaded &&
            (vehicleInspectionPanelCubit.state as VehicleInspectionDataLoaded)
                    .fieldKey !=
                widget.mapKey)) {
      await vehicleInspectionPanelCubit.fetchInspectionChecklist(widget.mapKey);
    }
    await vehicleInspectionPanelCubit.fetchSubmittedInspectionData(
      selectionCubit.state.taxiPlateNo,
      widget.mapKey,
    );
  }
}
