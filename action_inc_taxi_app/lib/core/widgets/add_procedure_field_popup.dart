import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';

class AddProcedureFieldPopup extends StatefulWidget {
  final List<String> sections;
  final String procedureType;
  final bool isEdit;
  final String? initialCategory;
  final FieldModel? initialField;
  const AddProcedureFieldPopup({
    super.key,
    required this.sections,
    required this.procedureType,
    this.isEdit = false,
    this.initialCategory,
    this.initialField,
  });

  @override
  State<AddProcedureFieldPopup> createState() => _AddProcedureFieldPopupState();
}

class _AddProcedureFieldPopupState extends State<AddProcedureFieldPopup> {
  late String _selectedSection;
  bool _isCustomSection = false;
  final TextEditingController _customSectionController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sections.isNotEmpty) {
      _selectedSection = widget.sections.first;
    }
    if (widget.isEdit && widget.initialCategory != null) {
      _selectedSection = widget.initialCategory!;
    }
    if (widget.isEdit && widget.initialField != null) {
      _fieldNameController.text = widget.initialField!.fieldName;
    }
  }

  @override
  void dispose() {
    _customSectionController.dispose();
    _fieldNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProcedureCubit procedureCubit = context.read<ProcedureCubit>();
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 100.w,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.white, size: 4.sp),
                  ),
                ],
              ),
              Spacing.vMedium,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ResponsiveText(
                      "Select Section",
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                  ),
                  Spacing.hStandard,
                  Expanded(
                    flex: 2,
                    child: AppDropdown<String>(
                      value: _selectedSection,
                      items: [
                        ...widget.sections,
                        'Add new...'
                      ]
                          .map(
                            (section) => DropdownMenuItem<String>(
                              value: section,
                              child: ResponsiveText(
                                section,
                                style: AppTextStyles.bodyExtraSmall,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSection = value!;
                          _isCustomSection = value == 'Add new...';
                          if (!_isCustomSection && widget.sections.isNotEmpty) {
                            _customSectionController.clear();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_isCustomSection) ...[
                Spacing.vMedium,
                Row(
                  children: [
                    Expanded(
                      child: ResponsiveText(
                        "New Section Name",
                        style: AppTextStyles.bodyExtraSmall,
                      ),
                    ),
                    Spacing.hStandard,
                    Expanded(
                      flex: 2,
                      child: AppTextFormField(
                        controller: _customSectionController,
                        hintText: "Enter section name",
                        labelText: null,
                        labelOnTop: false,
                      ),
                    ),
                  ],
                ),
              ],
              Spacing.vLarge,
              Row(
                children: [
                  Expanded(
                    child: ResponsiveText(
                      "Field Name",
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                  ),
                  Spacing.hStandard,
                  Expanded(
                    flex: 2,
                    child: AppTextFormField(
                      controller: _fieldNameController,
                      hintText: "Enter field name",
                      labelText: null,
                      labelOnTop: false,
                    ),
                  ),
                ],
              ),
              Spacing.vExtraLarge,
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    final String sectionName = _isCustomSection
                        ? _customSectionController.text.trim()
                        : _selectedSection;
                    if (sectionName.isEmpty) return;
                    if (_fieldNameController.text.trim().isEmpty) return;
                    procedureCubit.updateProcedureChecklist(
                      widget.procedureType,
                      CategoryModel(
                        categoryName: sectionName,
                        fields: [
                          FieldModel(
                            fieldName: _fieldNameController.text,
                            fieldKey: _fieldNameController.text
                                .toLowerCase()
                                .replaceAll(' ', '_'),
                          ),
                        ],
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: ResponsiveText(
                    "Add Field",
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: AppColors.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
