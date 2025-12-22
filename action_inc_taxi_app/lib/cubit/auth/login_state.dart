part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final EmployeeModel user;
  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
