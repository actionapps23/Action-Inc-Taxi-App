import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/procedure_model.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_state.dart';
import 'package:action_inc_taxi_app/services/procedure_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcedureCubit extends Cubit<ProcedureState> {
  ProcedureCubit() : super(ProcedureInitial());

  Future<void> submitProcedureRecord(ProcedureModel procedure) async {
    emit(ProcedureRecordSubmitting());
    try {
      await ProcedureService.submitProcedureRecord(procedure);
      emit(ProcedureRecordSubmitted());
    } catch (e) {
      emit(ProcedureRecordSubmissionFailed(errorMessage: AppConstants.procedureRecordSubmissionError));
    }
  }

  Future<void> updateProcedureChecklist(String checklistType, CategoryModel category) async {
    emit(ProcedureChecklistUpdating());
    try {
      await ProcedureService.updateProcedureChecklist(checklistType, category);
      emit(ProcedureChecklistUpdated());
    } catch (e) {
      emit(ProcedureChecklistUpdateFailed(errorMessage: AppConstants.procedureChecklistUpdateError));
    }
  }

}