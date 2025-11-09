import 'package:equatable/equatable.dart';

abstract class RenewalAndStatusState extends Equatable {
  const RenewalAndStatusState();

  @override
  List<Object?> get props => [];
}

class RenewalAndStatusInitial extends RenewalAndStatusState {}

class RenewalAndStatusLoading extends RenewalAndStatusState {}

class RenewalAndStatusLoaded extends RenewalAndStatusState {
  final List<Map<String, dynamic>> allRows;
  final List<Map<String, dynamic>> filteredRows;
  final int selectedFilter; // 0: week, 1: month, 2: year

  const RenewalAndStatusLoaded({required this.allRows, required this.filteredRows, required this.selectedFilter});

  RenewalAndStatusLoaded copyWith({List<Map<String, dynamic>>? allRows, List<Map<String, dynamic>>? filteredRows, int? selectedFilter}) {
    return RenewalAndStatusLoaded(
      allRows: allRows ?? this.allRows,
      filteredRows: filteredRows ?? this.filteredRows,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [allRows, filteredRows, selectedFilter];
}

class RenewalAndStatusFailure extends RenewalAndStatusState {
  final String error;
  const RenewalAndStatusFailure(this.error);

  @override
  List<Object?> get props => [error];
}
