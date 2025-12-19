import 'package:action_inc_taxi_app/core/models/car_detail_model.dart';

abstract class CarDetailState {
  final int selectedIndex;
  const CarDetailState({this.selectedIndex = 0});
}

class CarDetailInitial extends CarDetailState {}

class CarDetailLoaded extends CarDetailState {
  final CarDetailModel? carDetailModel;

  const CarDetailLoaded({this.carDetailModel, super.selectedIndex});

  CarDetailLoaded copyWith({
    CarDetailModel? carDetailModel,
    int? selectedIndex,
  }) {
    return CarDetailLoaded(
      carDetailModel: carDetailModel ?? this.carDetailModel,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class CarDetailError extends CarDetailState {
  final String message;

  const CarDetailError(this.message);
}
