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
        emit(DailyRentLoaded(carInfo: carInfo, driver: driver, rent: rent, fieldErrors: {}));
      } else {
        emit(DailyRentLoaded(carInfo: car, fieldErrors: {}));
      }
    } catch (e) {
      emit(DailyRentError(e.toString()));
    }
  }

  /// Persist current draft to DB (drafts collection) so returning to the screen restores values.
  Future<void> saveDraft() async {
    final current = state;
    if (current is! DailyRentLoaded) return;
    try {
      final carMap = current.carInfo?.toMap();
      final driverMap = current.driver?.toMap();
      final rentMap = current.rent?.toMap();
      final taxiNo = current.carInfo?.taxiNo ?? current.rent?.taxiNo ?? '';
      if (taxiNo.isEmpty) return;
      await dbService.saveDraftForTaxi(
        taxiNo: taxiNo,
        rent: rentMap,
        driver: driverMap,
        car: carMap,
      );
    } catch (_) {
      // ignore save errors for drafts
    }
  }

  void updateDraft({
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

  Map<String, String> validateDraft(Rent r) {
    return r.validate();
  }

  // Final save helpers (will be called after multi-step collection). Not invoked on Next per requirement.
  Future<void> persistAll({
    required CarInfo car,
    Driver? driver,
    required Rent rent,
  }) async {
    emit(DailyRentSaving());
    try {
      String driverId = driver?.id ?? '';
      if (driver != null && driverId.isEmpty) {
        driverId = await dbService.saveDriver(driver);
      }
      // ensure car has driverId
      final carToSave = CarInfo(
        id: car.id.isNotEmpty ? car.id : car.taxiNo,
        taxiNo: car.taxiNo,
        plateNumber: car.plateNumber,
        fleetNo: car.fleetNo,
        driverId: driverId.isNotEmpty ? driverId : car.driverId,
        createdAtUtc: car.createdAtUtc,
      );
      await dbService.saveCar(carToSave);
      final rentToSave = Rent(
        id: rent.id,
        taxiNo: rent.taxiNo,
        driverId: driverId.isNotEmpty ? driverId : rent.driverId,
        dateUtc: rent.dateUtc,
        contractStartUtc: rent.contractStartUtc,
        contractEndUtc: rent.contractEndUtc,
        monthsCount: rent.monthsCount,
        extraDays: rent.extraDays,
        rentAmountCents: rent.rentAmountCents,
        maintenanceFeesCents: rent.maintenanceFeesCents,
        carWashFeesCents: rent.carWashFeesCents,
        paymentCashCents: rent.paymentCashCents,
        paymentGCashCents: rent.paymentGCashCents,
        gCashRef: rent.gCashRef,
        isPublicHoliday: rent.isPublicHoliday,
        isBirthday: rent.isBirthday,
        createdAtUtc: rent.createdAtUtc,
      );
      await dbService.saveRent(rentToSave);
      emit(DailyRentSaved());
    } catch (e) {
      emit(DailyRentError(e.toString()));
    }
  }
}
