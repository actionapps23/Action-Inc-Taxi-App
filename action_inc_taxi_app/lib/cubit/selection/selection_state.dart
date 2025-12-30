import 'package:equatable/equatable.dart';

class SelectionState extends Equatable {
  final String taxiNo;
  final String regNo;
  final String driverName;
  final String taxiPlateNo;

  const SelectionState({
    required this.taxiPlateNo,
    required this.taxiNo,
    required this.regNo,
    required this.driverName,
  });

  SelectionState copyWith({
    String? taxiPlateNo,
    String? taxiNo,
    String? regNo,
    String? driverName,
  }) {
    return SelectionState(
      taxiNo: taxiNo ?? this.taxiNo,
      taxiPlateNo: taxiPlateNo ?? this.taxiPlateNo,
      regNo: regNo ?? this.regNo,
      driverName: driverName ?? this.driverName,
    );
  }

  @override
  List<Object?> get props => [taxiNo, regNo, driverName, taxiPlateNo];
}
