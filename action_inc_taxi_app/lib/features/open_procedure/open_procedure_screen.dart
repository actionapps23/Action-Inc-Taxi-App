// import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
// import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
// import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
// import 'package:action_inc_taxi_app/core/widgets/add_procedure_field_popup.dart';
// import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
// import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
// import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
// import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
// import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
// import 'package:action_inc_taxi_app/cubit/procedure/procedure_cubit.dart';
// import 'package:action_inc_taxi_app/cubit/procedure/procedure_state.dart';
// import 'package:action_inc_taxi_app/features/open_procedure/procedure_section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class OpenProcedureScreen extends StatefulWidget {
//   const OpenProcedureScreen({super.key});

//   @override
//   State<OpenProcedureScreen> createState() => _OpenProcedureScreenState();
// }

// class _OpenProcedureScreenState extends State<OpenProcedureScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final ProcedureCubit procedureCubit = context.read<ProcedureCubit>();
//       procedureCubit.fetchProcedureChecklist("open_procedure");
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final ProcedureCubit procedureCubit = BlocProvider.of<ProcedureCubit>(context);
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//           child: Column(
//             children: [
//               Navbar(),
//               Spacing.vLarge,
//               ResponsiveText(
//                 'Open Procedure',
//                 style: AppTextStyles.bodySmall,
//               ),
//               Spacing.vLarge,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   AppOutlineButton(
//                     onPressed: () {
//                       showDialog(context: context, builder: (context) => AddProcedureFieldPopup(sections: ["Taxi Office", "Garage"], procedureType: AppConstants.openProcedure,));
//                     },
//                    label: "Add new field",
//                   ),
//                 ],
//               ),
//               Spacing.vLarge,
//               BlocBuilder(
//                 bloc: procedureCubit,
//                 builder: (context , state) {
//                   if (state is ProcedureLoading ||
//                       state is ProcedureInitial ||
//                       state is ProcedureChecklistUpdating ||
//                       state is ProcedureRecordSubmitting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if(state is ProcedureError) {
//                     return Center(
//                       child: ResponsiveText(
//                         state.errorMessage!,
//                         style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
//                       ),
//                     );
//                   }
//                   if(state is ProcedureRecordSubmissionFailed){
//                     return Center(
//                       child: ResponsiveText(
//                         state.errorMessage!,
//                         style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
//                       ),
//                     );
//                   }
//                   if (state is ProcedureRecordSubmitted) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       SnackBarHelper.showSuccessSnackBar(context, "Added");
//                     });
//                   }
//                   return Expanded(
//                     child: ListView(
//                       children: (state as ProcedureLoaded).procedureModel!.categories
//                           .map((category) => ProcedureSection(category: category))
//                           .toList(),
//                     ),
//                   );
//                 }
//               ),
//               AppButton(
//                 text: "Submit",
//                 onPressed: () {
//                   procedureCubit.submitProcedureRecord(
//                     (procedureCubit.state as ProcedureLoaded).procedureModel!,
//                   );
//                 },
//                 width: 40.w,
//                 height: 44.h,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
