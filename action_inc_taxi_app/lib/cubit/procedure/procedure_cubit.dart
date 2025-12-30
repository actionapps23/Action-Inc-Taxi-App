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
      final submittedProcedure = await ProcedureService.fetchProcedureRecord(
        procedure.procedureType,
        null,
      );
      emit(ProcedureRecordAlreadySubmitted(procedureModel: submittedProcedure));
    } catch (e) {
      emit(
        ProcedureRecordSubmissionFailed(
          errorMessage: AppConstants.procedureRecordSubmissionError,
        ),
      );
    }
  }

  Future<void> deleteProcedureChecklist(
    String checklistType,
    String categoryName,
    String fieldKey,
  ) async {
    emit(ProcedureChecklistUpdating());
    try {
      await ProcedureService.deleteProcedureChecklist(
        checklistType,
        categoryName,
        fieldKey,
      );
      await fetchProcedureChecklist(checklistType);
    } catch (e) {
      emit(
        ProcedureChecklistUpdateFailed(
          errorMessage: AppConstants.procedureChecklistUpdateError,
        ),
      );
    }
  }

  Future<void> updateProcedureChecklist(
    String checklistType,
    CategoryModel category,
  ) async {
    emit(ProcedureChecklistUpdating());
    try {
      await ProcedureService.updateProcedureChecklist(checklistType, category);
      await fetchProcedureChecklist(checklistType);
    } catch (e) {
      emit(
        ProcedureChecklistUpdateFailed(
          errorMessage: AppConstants.procedureChecklistUpdateError,
        ),
      );
    }
  }

  Future<void> isRecordSubmitted(String procedureType) async {
    emit(ProcedureLoading());
    try {
      final procedure = await ProcedureService.fetchProcedureRecord(
        procedureType,
        null,
      );
      if (procedure != null) {
        emit(ProcedureRecordAlreadySubmitted(procedureModel: procedure));
        return;
      }

      final procedureChecklist = await fetchProcedureChecklist(procedureType);
      emit(ProcedureLoaded(procedureModel: procedureChecklist));
    } catch (e) {
      emit(ProcedureError(errorMessage: AppConstants.genericErrorMessage));
    }
  }

  Future<ProcedureModel> fetchProcedureChecklist(String checklistType) async {
    emit(ProcedureLoading());
    try {
      final procedure = await ProcedureService.fetchProcedureChecklist(
        checklistType,
      );
      emit(ProcedureLoaded(procedureModel: procedure));
      return procedure;
    } catch (e) {
      emit(ProcedureError(errorMessage: AppConstants.procedureFetchError));
      rethrow;
    }
  }

  void toggleField(String fieldKey, String categoryName) {
    final currentState = state as ProcedureLoaded;
    final List<CategoryModel> updatedCategories =
        currentState.procedureModel!.categories;
    final categoryToBeUpdated = updatedCategories.firstWhere(
      (category) => category.categoryName == categoryName,
    );
    final fieldToBeUpdated = categoryToBeUpdated.fields.firstWhere(
      (field) => field.fieldKey == fieldKey,
    );
    bool isChecked = !fieldToBeUpdated.isChecked;
    final updatedField = FieldModel(
      fieldKey: fieldToBeUpdated.fieldKey,
      fieldName: fieldToBeUpdated.fieldName,
      isChecked: isChecked,
    );
    final updatedFields = categoryToBeUpdated.fields.map((field) {
      if (field.fieldKey == fieldKey) {
        return updatedField;
      }
      return field;
    }).toList();

    final updatedCategory = categoryToBeUpdated.copyWith(fields: updatedFields);
    final updatedCategoriesFinal = updatedCategories.map((category) {
      if (category.categoryName == categoryName) {
        return updatedCategory;
      }
      return category;
    }).toList();

    emit(
      ProcedureLoaded(
        procedureModel: state.procedureModel!.copyWith(
          categories: updatedCategoriesFinal,
        ),
      ),
    );
  }
}
