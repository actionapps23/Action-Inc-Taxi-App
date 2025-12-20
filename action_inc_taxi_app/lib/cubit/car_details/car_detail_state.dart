import 'package:action_inc_taxi_app/core/models/car_detail_model.dart';

class CarDetailState {
  final int selectedIndex;
  final CarDetailModel? carDetailModel;
  const CarDetailState({this.selectedIndex = 0, this.carDetailModel});

  CarDetailState copyWith({
    int? selectedIndex,
    CarDetailModel? carDetailModel,
  }) {
    return CarDetailState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      carDetailModel: carDetailModel ?? this.carDetailModel,
    );
  }
}

class CarDetailInitial extends CarDetailState {
  const CarDetailInitial({super.selectedIndex, super.carDetailModel});

  @override
  CarDetailInitial copyWith({
    int? selectedIndex,
    CarDetailModel? carDetailModel,
  }) {
    return CarDetailInitial(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      carDetailModel: carDetailModel ?? this.carDetailModel,
    );
  }
}

class CarDetailLoaded extends CarDetailState {
  const CarDetailLoaded({super.selectedIndex, super.carDetailModel});

  @override
  CarDetailLoaded copyWith({
    CarDetailModel? carDetailModel,
    int? selectedIndex,
  }) {
    return CarDetailLoaded(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      carDetailModel: carDetailModel ?? this.carDetailModel,
    );
  }
}

class CarDetailError extends CarDetailState {
  final String message;

  const CarDetailError(this.message);
}

class CarDetailNotFound extends CarDetailState {
  const CarDetailNotFound() : super();
}
