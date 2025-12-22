import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';

class MaintainanceState {
  final List<MaintainanceModel> maintainanceItems;
  MaintainanceState({required this.maintainanceItems});

  MaintainanceState copyWith({List<MaintainanceModel>? maintainanceItems}) {
    return MaintainanceState(
      maintainanceItems: maintainanceItems ?? this.maintainanceItems,
    );
  }
}

class MaintainanceInitial extends MaintainanceState {
  MaintainanceInitial() : super(maintainanceItems: []);
}

class MaintainanceLoading extends MaintainanceState {
  MaintainanceLoading() : super(maintainanceItems: []);
}

class MaintainanceLoaded extends MaintainanceState {
  MaintainanceLoaded({required super.maintainanceItems});
}

class MaintainanceError extends MaintainanceState {
  final String message;
  MaintainanceError({required this.message}) : super(maintainanceItems: []);
}

class MaintainanceEmpty extends MaintainanceState {
  MaintainanceEmpty() : super(maintainanceItems: []);
}
