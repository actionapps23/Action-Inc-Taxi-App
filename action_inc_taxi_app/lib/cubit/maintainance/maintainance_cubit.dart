import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_state.dart';
import 'package:action_inc_taxi_app/services/maintainance_db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintainanceCubit extends Cubit<MaintainanceState> {
  MaintainanceCubit() : super(MaintainanceInitial());

  Future<void> fetchMaintainanceItems() async {
    emit(MaintainanceLoading());
    final List<MaintainanceModel> items =
        await MaintainanceDbService.fetchMaintainanceRequests();
    if (items.isEmpty) {
      emit(MaintainanceEmpty());
      return;
    }
    emit(MaintainanceLoaded(maintainanceItems: items));
  }

  Future<void> addMaintainanceRequest(MaintainanceModel request) async {
    emit(MaintainanceLoading());
    try {
      await MaintainanceDbService.addMaintainanceRequest(request);
      await fetchMaintainanceItems();
    } catch (e) {
      emit(MaintainanceError(message: e.toString()));
    }
  }
}
