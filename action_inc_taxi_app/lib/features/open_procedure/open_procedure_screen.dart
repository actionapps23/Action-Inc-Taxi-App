
import 'package:action_inc_taxi_app/core/models/procedure_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_cubit.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_state.dart';
import 'package:action_inc_taxi_app/features/open_procedure/procedure_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpenProcedureScreen extends StatefulWidget {
  final ProcedureModel procedureModel;
  const OpenProcedureScreen({super.key, required this.procedureModel});

  @override
  State<OpenProcedureScreen> createState() => _OpenProcedureScreenState();
}

class _OpenProcedureScreenState extends State<OpenProcedureScreen> {
  @override
  Widget build(BuildContext context) {
    final ProcedureCubit procedureCubit = BlocProvider.of<ProcedureCubit>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            children: [
              Navbar(),
              Spacing.vLarge,
              Text(
                'Open Procedure',
                style: AppTextStyles.bodySmall,
              ),
              Spacing.vLarge,
              BlocBuilder(
                bloc: procedureCubit,
                builder: (context , state) {
                  if (state is ProcedureLoading ||
                      state is ProcedureInitial ||
                      state is ProcedureChecklistUpdating ||
                      state is ProcedureRecordSubmitting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(state is ProcedureError) {
                    return Center(
                      child: Text(
                        state.errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
                      ),
                    );
                  }
                  if(state is ProcedureRecordSubmissionFailed){
                    return Center(
                      child: Text(
                        state.errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: state is ProcedureRecordSubmitted
                          ? [Center(
                              child: Text(
                                'Procedure Submitted Successfully',
                                style: AppTextStyles.bodySmall,
                              ),
                            )]
                          : widget.procedureModel.categories
                          .map((category) => ProcedureSection(category: category))
                          .toList(),
                    ),
                  );
                }
              ),
              ],
          ),
        ),
      ),
    );
  }
}
