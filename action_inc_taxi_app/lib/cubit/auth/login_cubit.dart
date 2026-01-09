import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/employee_model.dart';
import 'package:action_inc_taxi_app/core/storage/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final DbService dbService = DbService();

  LoginCubit() : super(LoginInitial());

  Future<void> isLoggedIn() async {
    emit(LoginLoading());
    try {
      final isLoggedIn = await LocalStorage.isLoggedIn();
      if (isLoggedIn) {
        final employeeId = await LocalStorage.getID();
        final token = await LocalStorage.getToken();
        final employeeModel = await dbService.getEmployeeById(employeeId!);
        if (employeeModel != null && employeeModel.token == token) {
          final savedRoute = await LocalStorage.getLastRoute();
          emit(LoginSuccess(employeeModel, savedRoute: savedRoute));
        } else {
          emit(LoginInitial());
        }
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> login(String employeeId, String hashPassword) async {
    emit(LoginLoading());
    try {
      final token = Uuid().v4();
      EmployeeModel? employeeModel = await dbService.loginWithEmployeeId(
        employeeId,
        hashPassword,
      );
      if (employeeModel != null) {
        employeeModel = employeeModel.copyWith(token: token);
        await LocalStorage.saveToken(token);
        await LocalStorage.saveID(employeeModel.employeeId);
        await dbService.updateEmployeeToken(employeeModel.employeeId, token);
        emit(LoginSuccess(employeeModel));
      } else {
        emit(LoginFailure('Invalid employee ID or password.'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(LoginLoading());
    try {
      await LocalStorage.clear();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> updateEmployeePassword(
    String currentHashPassword,
    String newHashPassword,
  ) async {
    try {
      emit(UpdatePasswordLoading());
      final employeeID = await LocalStorage.getID();
      await dbService.updateEmployeePassword(
        employeeID!,
        currentHashPassword,
        newHashPassword,
      );
      emit(UpdatePasswordSuccess());
    } catch (e) {
      emit(UpdatePasswordFailure(e.toString()));
    }
  }
}
