import 'package:action_inc_taxi_app/services/employee_service.dart';
import 'package:action_inc_taxi_app/core/models/employee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_employee_state.dart';

class AddEmployeeCubit extends Cubit<AddEmployeeState> {
  AddEmployeeCubit() : super(AddEmployeeInitial());

  Future<void> addEmployee({
    required String employeeId,
    required String name,
    required String password,
    required String role,
    required bool isAdmin,
  }) async {
    emit(AddEmployeeLoading());
    try {
      final employee = EmployeeModel(
        employeeId: employeeId,
        name: name,
        password: password,
        role: role,
        isAdmin: isAdmin,
        createdAt: DateTime.now(),
      );
      await EmployeeService.addEmployee(employee);
      emit(AddEmployeeSuccess());
    } catch (e) {
      emit(AddEmployeeFailure(e.toString()));
    }
  }

  Future<String> getNextEmployeeId() async {
    try {
      final nextId = await EmployeeService.getNextEmployeeId();
      return nextId;
    } catch (e) {
      return 'emp001';
    }
  }
}
