import 'package:action_inc_taxi_app/core/models/car_info.dart';
import 'package:action_inc_taxi_app/core/models/driver.dart';
import 'package:action_inc_taxi_app/core/models/rent.dart';

class CarDetailModel {
  final Driver driver;
  final Rent rent;
  final CarInfo carInfo;

  CarDetailModel({
    required this.driver,
    required this.rent,
    required this.carInfo,
  });
  factory CarDetailModel.fromMap(Map<String, dynamic> map) {
    return CarDetailModel(
      driver: Driver.fromMap(map['driver'] as Map<String, dynamic>),
      rent: Rent.fromMap(map['rent'] as Map<String, dynamic>),
      carInfo: CarInfo.fromMap(map['carInfo'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'driver': driver.toMap(),
      'rent': rent.toMap(),
      'carInfo': carInfo.toMap(),
    };
  }
}
