import 'package:action_inc_taxi_app/core/models/procedure_model.dart';

class ProcedureState {
  final String? errorMessage;
  final ProcedureModel? procedureModel;
  ProcedureState({this.errorMessage, this.procedureModel});
}

class ProcedureInitial extends ProcedureState {}

class ProcedureRecordSubmitting extends ProcedureState {
  ProcedureRecordSubmitting();
}

class ProcedureRecordSubmitted extends ProcedureState {
  ProcedureRecordSubmitted();
}

class ProcedureRecordSubmissionFailed extends ProcedureState {
  ProcedureRecordSubmissionFailed({required super.errorMessage});
}

class ProcedureChecklistUpdating extends ProcedureState {
  ProcedureChecklistUpdating();
}

class ProcedureChecklistUpdated extends ProcedureState {
  ProcedureChecklistUpdated();
}

class ProcedureChecklistUpdateFailed extends ProcedureState {
  ProcedureChecklistUpdateFailed({required super.errorMessage});
}

class ProcedureLoading extends ProcedureState {
  ProcedureLoading();
}

class ProcedureLoaded extends ProcedureState {
  ProcedureLoaded({required super.procedureModel});
}

class ProcedureError extends ProcedureState {
  ProcedureError({required super.errorMessage});
}
