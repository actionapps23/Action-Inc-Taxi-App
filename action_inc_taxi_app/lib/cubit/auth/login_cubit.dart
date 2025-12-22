import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/employeee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final DbService dbService = DbService();

  LoginCubit() : super(LoginInitial());

  Future<void> login(String employeeId, String hashPassword) async {
    emit(LoginLoading());
    try {
      final EmployeeModel? employeeModel = await dbService.loginWithEmployeeId(
        employeeId,
        hashPassword,
      );
      if (employeeModel != null) {
        emit(LoginSuccess(employeeModel));
      } else {
        emit(LoginFailure('Invalid employee ID or password.'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
