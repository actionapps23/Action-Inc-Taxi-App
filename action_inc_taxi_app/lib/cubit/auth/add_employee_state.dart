part of 'add_employee_cubit.dart';

abstract class AddEmployeeState {}

class AddEmployeeInitial extends AddEmployeeState {}

class AddEmployeeLoading extends AddEmployeeState {}

class AddEmployeeSuccess extends AddEmployeeState {}

class AddEmployeeFailure extends AddEmployeeState {
  final String error;
  AddEmployeeFailure(this.error);
}
