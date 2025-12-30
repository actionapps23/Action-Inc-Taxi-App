import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/add_procedure_field_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_cubit.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_state.dart';
import 'package:action_inc_taxi_app/features/open_procedure/procedure_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcedureScreen extends StatefulWidget {
  final String procedureType;
  const ProcedureScreen({super.key, required this.procedureType});

  @override
  State<ProcedureScreen> createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ProcedureCubit procedureCubit = context.read<ProcedureCubit>();
      procedureCubit.isRecordSubmitted(widget.procedureType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProcedureCubit procedureCubit = BlocProvider.of<ProcedureCubit>(
      context,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            children: [
              Navbar(),
              Spacing.vLarge,
              ResponsiveText(
                widget.procedureType == AppConstants.closeProcedure
                    ? 'Close Procedure'
                    : 'Open Procedure',
                style: AppTextStyles.bodySmall,
              ),
              Spacing.vLarge,
              BlocBuilder(
                bloc: procedureCubit,
                builder: (context, state) {
                  final bool alreadySubmitted =
                      state is ProcedureRecordAlreadySubmitted;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state is ProcedureLoaded && !alreadySubmitted)
                        AppOutlineButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddProcedureFieldPopup(
                                sections: state.procedureModel!.categories
                                    .map((e) => e.categoryName)
                                    .toList(),
                                procedureType: widget.procedureType,
                                onSubmit:
                                    ({
                                      required sectionName,
                                      required fieldName,
                                    }) {
                                      procedureCubit.updateProcedureChecklist(
                                        widget.procedureType,
                                        CategoryModel(
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
                  );
                },
              ),
              Spacing.vLarge,
              Expanded(
                child: BlocBuilder(
                  bloc: procedureCubit,
                  builder: (context, state) {
                    if (state is ProcedureLoading ||
                        state is ProcedureInitial ||
                        state is ProcedureChecklistUpdating ||
                        state is ProcedureRecordSubmitting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ProcedureError) {
                      return Center(
                        child: ResponsiveText(
                          state.errorMessage!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    if (state is ProcedureRecordSubmissionFailed) {
                      return Center(
                        child: ResponsiveText(
                          state.errorMessage!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    if (state is ProcedureRecordSubmitted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        SnackBarHelper.showSuccessSnackBar(context, "Added");
                      });
                    }
                    if (state is ProcedureLoaded) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: (state).procedureModel!.categories
                                  .map(
                                    (category) => ProcedureSection(
                                      category: category,
                                      checklistType: widget.procedureType,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          AppButton(
                            text: "Submit",
                            onPressed: () {
                              procedureCubit.submitProcedureRecord(
                                (procedureCubit.state as ProcedureLoaded)
                                    .procedureModel!,
                              );
                            },
                            width: 40.w,
                            height: 44.h,
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: (state as ProcedureRecordAlreadySubmitted)
                                .procedureModel!
                                .categories
                                .map(
                                  (category) => ProcedureSection(
                                    category: category,
                                    checklistType: widget.procedureType,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        AppButton(
                          backgroundColor: Colors.grey,
                          text: "Submitted",
                          onPressed: () {},
                          width: 40.w,
                          height: 44.h,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
