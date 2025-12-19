import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/car_detail_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'car_detail_state.dart';

class CarDetailCubit extends Cubit<CarDetailState> {
  CarDetailCubit({int initialIndex = 0}) : super(CarDetailLoaded());
  final DbService dbService = DbService();
  void selectTab(int index) {
    final current = state;
    if (current is CarDetailLoaded) {
      if (current.selectedIndex != index) {
        emit(current.copyWith(selectedIndex: index));
      }
    } else {
      emit(CarDetailLoaded());
    }
  }

  void loadCarDetails(String taxiNo, String regNo) async {
    try {
      final CarDetailModel? carDetail = await dbService.getCarDetailInfo(
        taxiNo,
        regNo,
      );
      if (carDetail != null) {
        emit(CarDetailLoaded(carDetailModel: carDetail));
      } else {
        emit(CarDetailLoaded());
      }
    } catch (e) {
      emit(CarDetailError(e.toString()));
    }
  }
}
