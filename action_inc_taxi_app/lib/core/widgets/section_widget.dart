import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/add_procedure_field_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/field_action_menu.dart';
import 'package:action_inc_taxi_app/core/widgets/report_issue_popup.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_isnpection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

class SectionWidget extends StatelessWidget {
  final CategoryModel category;
  final String mapKey;
  const SectionWidget({super.key, required this.category, required this.mapKey});
  @override
  Widget build(BuildContext context) {
    final SelectionCubit selectionCubit = context.read<SelectionCubit>();
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
              ResponsiveText(
                category.categoryName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...category.fields.map(
                (field) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    ResponsiveText(field.fieldName),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.report),
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ReportIssuePopup(),
                              );
                            },
                          ),
                          Checkbox(
                            value: vehicleInspectionPanelCubit.isChecked(
                              field.fieldKey,
                            ),
                            onChanged: (value) {
                              vehicleInspectionPanelCubit.toggleField(
                                field.fieldKey,
                              );
                            },
                          ),

                          FieldActionsMenu(onEdit: (){
                            showDialog(context: context, builder: (context){
                              return AddProcedureFieldPopup(
                                sections: [category.categoryName],
                                initialCategory: category.categoryName,
                                initialField: field,
                                isEdit: true,
                                procedureType: '',
                                onSubmit: ({required String fieldName, required String sectionName}) {
                                  vehicleInspectionPanelCubit.updateInspectionChecklist(
                                    view: mapKey,
                                    category: CategoryModel(
                                      categoryName: sectionName,
                                      fields: category.fields.map((f) {
                                        if (f.fieldKey == field.fieldKey) {
                                          return FieldModel(
                                            fieldName: fieldName,
                                            fieldKey: field.fieldKey,
                                          );
                                        }
                                        return f;
                                      }).toList(),
                                    ),
                                  );
                                },
                              );
                            });

                          },
                           onDeleteConfirm: ()async{
                            final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: ResponsiveText('Delete field'),
                                      content: ResponsiveText(
                                        'Are you sure you want to delete this field?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: ResponsiveText('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: ResponsiveText('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                            if (confirmed == true) {
                            vehicleInspectionPanelCubit.updateInspectionChecklist(
                              view: mapKey,
                              category: CategoryModel(
                                categoryName: category.categoryName,
                                fields: category.fields.where((f) => f.fieldKey != field.fieldKey).toList(),
                              ),
                            
                            );}
                          })
                        ],
                      ),
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
