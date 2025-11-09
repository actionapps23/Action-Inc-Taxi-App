part of 'daily_rent_cubit.dart';

abstract class DailyRentState {}

class DailyRentInitial extends DailyRentState {}

class DailyRentLoading extends DailyRentState {}

class DailyRentLoaded extends DailyRentState {
  final CarInfo? carInfo;
  final Driver? driver;
  final Rent? rent;
  final Map<String, String> fieldErrors;

  DailyRentLoaded({
    this.carInfo,
    this.driver,
    this.rent,
    Map<String, String>? fieldErrors,
  }) : fieldErrors = fieldErrors ?? {};
}

class DailyRentSaving extends DailyRentState {}

class DailyRentSaved extends DailyRentState {}

class DailyRentError extends DailyRentState {
  final String message;
  DailyRentError(this.message);
}
