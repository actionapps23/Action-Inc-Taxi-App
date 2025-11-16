import 'package:equatable/equatable.dart';

abstract class CarDetailState extends Equatable {
  const CarDetailState();

  @override
  List<Object?> get props => [];
}

class CarDetailInitial extends CarDetailState {}

class CarDetailLoaded extends CarDetailState {
  final int selectedIndex;

  const CarDetailLoaded({required this.selectedIndex});

  CarDetailLoaded copyWith({int? selectedIndex}) {
    return CarDetailLoaded(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object?> get props => [selectedIndex];
}
