import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/car_info.dart';
import 'package:action_inc_taxi_app/core/models/driver.dart';
import 'package:action_inc_taxi_app/core/models/rent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_rent_state.dart';

class DailyRentCubit extends Cubit<DailyRentState> {
  final DbService dbService;

  DailyRentCubit(this.dbService) : super(DailyRentInitial());

  Future<void> initWithTaxiNo(String taxiNo) async {
    emit(DailyRentLoading());
    try {
      final car = await dbService.getCarByTaxiNo(taxiNo);
      // attempt to load a saved draft for this taxi and populate driver/rent if present
      Map<String, dynamic>? draft;
      try {
        draft = await dbService.getDraftForTaxi(taxiNo);
      } catch (_) {
        draft = null;
      }

      if (draft != null) {
        final rentMap = draft['rent'] as Map<String, dynamic>?;
        final driverMap = draft['driver'] as Map<String, dynamic>?;
        final carMap = draft['car'] as Map<String, dynamic>?;
        final rent = rentMap != null ? Rent.fromMap(rentMap) : null;
        final driver = driverMap != null ? Driver.fromMap(driverMap) : null;
        final carInfo = carMap != null ? CarInfo.fromMap(carMap) : car;
        emit(
          DailyRentLoaded(
            carInfo: carInfo,
            driver: driver,
            rent: rent,
            fieldErrors: {},
          ),
        );
      } else {
        emit(DailyRentLoaded(carInfo: car, fieldErrors: {}));
      }
    } catch (e) {
      emit(DailyRentError(e.toString()));
    }
  }

  Future<void> saveCarDetailInfo() async {
    final current = state;
    if (current is! DailyRentLoaded) return;
    try {
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
