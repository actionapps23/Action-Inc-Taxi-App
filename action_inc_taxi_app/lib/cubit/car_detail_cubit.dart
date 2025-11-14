import 'package:flutter_bloc/flutter_bloc.dart';
import 'car_detail_state.dart';

class CarDetailCubit extends Cubit<CarDetailState> {
  CarDetailCubit({int initialIndex = 0})
    : super(CarDetailLoaded(selectedIndex: initialIndex));

  void selectTab(int index) {
    final current = state;
    if (current is CarDetailLoaded) {
      if (current.selectedIndex != index) {
        emit(current.copyWith(selectedIndex: index));
      }
    } else {
      emit(CarDetailLoaded(selectedIndex: index));
    }
  }
}
