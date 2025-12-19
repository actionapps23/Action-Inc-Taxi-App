import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintainanceCubit extends Cubit<MaintainanceState> {
  MaintainanceCubit() : super(MaintainanceState(maintainanceItems: testData));
}

final List<MaintainanceModel> testData = [
  MaintainanceModel(
    title: 'Oil Change',
    description: 'Changed engine oil and filter',
    date: DateTime.now().subtract(Duration(days: 30)),
    taxiId: 'TX123',
    fleetId: 'FL456',
    inspectedBy: 'John Doe',
    assignedTo: 'Jane Smith',
    attachmentUrls: ['http://example.com/receipt1.jpg'],
  ),
  MaintainanceModel(
    title: 'Tire Rotation',
    description: 'Rotated all four tires',
    date: DateTime.now().subtract(Duration(days: 60)),
    taxiId: 'TX789',
    fleetId: 'FL456',
    inspectedBy: 'Alice Johnson',
    assignedTo: 'Bob Brown',
    attachmentUrls: ['http://example.com/receipt2.jpg'],
  ),

  MaintainanceModel(
    title: 'Brake Inspection',
    description: 'Inspected and replaced brake pads',
    date: DateTime.now().subtract(Duration(days: 90)),
    taxiId: 'TX456',
    fleetId: 'FL789',
    inspectedBy: 'Charlie Davis',
    assignedTo: 'Diana Evans',
    attachmentUrls: ['http://example.com/receipt3.jpg'],
  ),
];
