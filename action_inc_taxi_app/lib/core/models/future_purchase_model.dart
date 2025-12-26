// ignore_for_file: non_constant_identifier_names

import 'package:action_inc_taxi_app/core/helper_functions.dart';

class FuturePurchaseModel {
  final String id;
  final String franchiseName;
  final int slotsWeHave;
  final int carsWeHave;
  FuturePurchaseModel({
    String? id,
    required this.franchiseName,
    required this.slotsWeHave,
    required this.carsWeHave,
  }) : id = id ?? HelperFunctions.getKeyFromTitle(franchiseName);

  FuturePurchaseModel copyWith({
    String? id,
    String? franchiseName,
    int? slotsWeHave,
    int? carsWeHave,
  }) {
    return FuturePurchaseModel(
      id: id ?? this.id,
      franchiseName: franchiseName ?? this.franchiseName,
      slotsWeHave: slotsWeHave ?? this.slotsWeHave,
      carsWeHave: carsWeHave ?? this.carsWeHave,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'franchiseName': franchiseName,
      'slotsWeHave': slotsWeHave,
      'carsWeHave': carsWeHave,
    };
  }

  factory FuturePurchaseModel.fromJson(Map<String, dynamic> json) {
    return FuturePurchaseModel(
      id: json['id'],
      franchiseName: json['franchiseName'],
      slotsWeHave: json['slotsWeHave'],
      carsWeHave: json['carsWeHave'],
    );
  }
}
