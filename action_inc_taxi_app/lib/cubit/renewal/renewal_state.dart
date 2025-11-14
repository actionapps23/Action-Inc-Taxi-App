part of 'renewal_cubit.dart';

abstract class RenewalState {}

class RenewalInitial extends RenewalState {}

class RenewalLoading extends RenewalState {}

class RenewalLoaded extends RenewalState {
  final Renewal renewal;
  RenewalLoaded({required this.renewal});
}

class RenewalSaving extends RenewalState {}

class RenewalSaved extends RenewalState {}

class RenewalError extends RenewalState {
  final String message;
  RenewalError(this.message);
}
