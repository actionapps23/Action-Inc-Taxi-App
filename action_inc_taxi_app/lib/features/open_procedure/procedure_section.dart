import 'package:action_inc_taxi_app/core/widgets/field_action_menu.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/add_procedure_field_popup.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_cubit.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcedureSection extends StatelessWidget {
  final CategoryModel category;
  final String checklistType;
  const ProcedureSection({
    super.key,
    required this.category,
    required this.checklistType,
  });
  @override
  Widget build(BuildContext context) {
    final ProcedureCubit procedureCubit = context.read<ProcedureCubit>();
    return BlocBuilder<ProcedureCubit, ProcedureState>(
      bloc: procedureCubit,
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
              ...category.fields.map((field) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: ResponsiveText(field.fieldName)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: field.isChecked,
                          onChanged: (value) {
                            if (state is ProcedureLoaded) {
                              procedureCubit.toggleField(
                                field.fieldKey,
                                category.categoryName,
                              );
                            }
                          },
                        ),
                        (state is ProcedureLoaded)
                        // We only need to pass the current section in popup bcoz here we are editing existing field
                            ? FieldActionsMenu(
                                onEdit: () {
                                  final sections =
                                     [category.categoryName];
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AddProcedureFieldPopup(
                                      sections: sections,
                                      procedureType: checklistType,
                                      isEdit: true,
                                      initialCategory: category.categoryName,
                                      initialField: field,
                                      onSubmit:
                                          ({
                                            required fieldName,
                                            required sectionName,
                                          }) => procedureCubit
                                              .updateProcedureChecklist(
                                                checklistType,
                                                CategoryModel(
                                                  categoryName: sectionName,
                                                  fields: [
                                                    FieldModel(
                                                      fieldName: fieldName,
                                                      fieldKey: field.fieldKey,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                    ),
                                  );
                                },
                                onDeleteConfirm: () async {
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
                                    procedureCubit.deleteProcedureChecklist(
                                      checklistType,
                                      category.categoryName,
                                      field.fieldKey,
                                    );
                                  }
                                },
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
