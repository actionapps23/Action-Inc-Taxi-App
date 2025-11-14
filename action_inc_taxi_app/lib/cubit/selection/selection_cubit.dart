import 'package:flutter_bloc/flutter_bloc.dart';
import 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit()
      : super(const SelectionState(
          taxiNo: '',
          regNo: '',
          driverName: '',
        ));

  void setTaxiNo(String value) => emit(state.copyWith(taxiNo: value));
  void setRegNo(String value) => emit(state.copyWith(regNo: value));
  void setDriverName(String value) => emit(state.copyWith(driverName: value));

  void setAll({String? taxiNo, String? regNo, String? driverName}) => emit(
        state.copyWith(
          taxiNo: taxiNo ?? state.taxiNo,
          regNo: regNo ?? state.regNo,
          driverName: driverName ?? state.driverName,
        ),
      );

  void clear() => emit(const SelectionState(taxiNo: '', regNo: '', driverName: ''));
}
