part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final EmployeeModel user;
  final String? savedRoute;
  LoginSuccess(this.user, {this.savedRoute});

  LoginSuccess copyWith({String? savedRoute}) {
    return LoginSuccess(user, savedRoute: savedRoute ?? this.savedRoute);
  }
}

class UpdatePasswordSuccess extends LoginState {}

class UpdatePasswordFailure extends LoginState {
  final String error;
  UpdatePasswordFailure(this.error);
}

class UpdatePasswordLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
