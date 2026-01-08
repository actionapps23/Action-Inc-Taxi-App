import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/car_info.dart';
import 'package:action_inc_taxi_app/core/models/driver.dart';
import 'package:action_inc_taxi_app/core/models/rent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_rent_state.dart';

class DailyRentCubit extends Cubit<DailyRentState> {
  final DbService dbService;

  DailyRentCubit(this.dbService) : super(DailyRentInitial());


  Future<void> saveCarDetailInfo() async {
    final current = state;
    if (current is! DailyRentLoaded) return;
    try {
      await dbService.saveCar(current.carInfo!);
      await dbService.saveDriver(current.driver!);
      await dbService.saveRent(current.rent!);
      await dbService.saveCarDetailInfo(
        car: current.carInfo?.toMap(),
        driver: current.driver?.toMap(),
        rent: current.rent?.toMap(),
      );
    } catch (_) {}
  }

  void update({
    CarInfo? carInfo,
    Driver? driver,
    Rent? rent,
    Map<String, String>? fieldErrors,
  }) {
    final current = state;
    emit(
      DailyRentLoaded(
        carInfo:
            carInfo ?? (current is DailyRentLoaded ? current.carInfo : null),
        driver: driver ?? (current is DailyRentLoaded ? current.driver : null),
        rent: rent ?? (current is DailyRentLoaded ? current.rent : null),
        fieldErrors:
            fieldErrors ??
            (current is DailyRentLoaded ? current.fieldErrors : {}),
      ),
    );
  }

  void reset() {
    emit(DailyRentInitial());
  }
}
