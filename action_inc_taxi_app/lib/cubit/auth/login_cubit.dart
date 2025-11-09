import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final DbService dbService;

  LoginCubit(this.dbService) : super(LoginInitial());

  Future<void> login(String employeeId, String hashPassword) async {
    emit(LoginLoading());
    try {
      final creds = await dbService.loginWithEmployeeId(
        employeeId,
        hashPassword,
      );
      if (creds != null) {
        emit(LoginSuccess(creds));
      } else {
        emit(LoginFailure('Invalid employee ID or password.'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
