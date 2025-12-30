import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/car_detail_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'car_detail_state.dart';

class CarDetailCubit extends Cubit<CarDetailState> {
  CarDetailCubit({int initialIndex = 0}) : super(CarDetailInitial());
  final DbService dbService = DbService();
  void selectTab(int index) {
    if (index != state.selectedIndex) {
      emit(state.copyWith(selectedIndex: index));
    }
  }

  void loadCarDetails(String taxiNo, String regNo, String taxiPlateNo) async {
    try {
      final CarDetailModel? carDetail = await dbService.getTaxiDetailInfo(
        taxiNo,
        regNo,
        taxiPlateNo,
      );
      if (carDetail != null) {
        emit(CarDetailLoaded(carDetailModel: carDetail));
      } else {
        emit(CarDetailNotFound());
      }
    } catch (e) {
      emit(CarDetailError(e.toString()));
    }
  }
}
