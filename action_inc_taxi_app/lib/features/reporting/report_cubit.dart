import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import '../../services/report_service.dart';
import 'report_state.dart';
import 'models/report_row.dart';
import 'package:uuid/uuid.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportState.initial());

  void addRow(ReportRow row) {
    final newRows = List<ReportRow>.from(state.rows)..add(row);
    emit(state.copyWith(rows: newRows));
  }

  void setRows(List<ReportRow> rows) {
    emit(state.copyWith(rows: List<ReportRow>.from(rows)));
  }

  void removeRowAt(int index) {
    final newRows = List<ReportRow>.from(state.rows)..removeAt(index);
    emit(state.copyWith(rows: newRows));
  }

  void updateRowAt(int index, ReportRow row) {
    final newRows = List<ReportRow>.from(state.rows);
    newRows[index] = row;
    emit(state.copyWith(rows: newRows));
  }

  Future<void> generatePdf({
    required String generatedBy,
    DateTime? generatedAt,
  }) async {
    try {
      emit(state.copyWith(status: ReportStatus.generating));
      final rows = state.rows
          .map(
            (r) => {
              'date': r.date.toIso8601String().split('T').first,
              'plateNumber': r.plateNumber,
              'vehicleModel': r.vehicleModel,
              'driverName': r.driverName,
              'cleanliness': r.cleanliness,
              'remarks': r.remarks,
            },
          )
          .toList();
      final Uint8List bytes = await ReportService.generateReportPdf(
        rows,
        generatedBy: generatedBy,
        generatedAt: generatedAt ?? DateTime.now(),
      );
      emit(state.copyWith(status: ReportStatus.ready, pdfBytes: bytes));
    } catch (e) {
      emit(
        state.copyWith(status: ReportStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> previewPdf() async {
    if (state.pdfBytes == null) return;
    await ReportService.previewPdf(state.pdfBytes!);
  }

  Future<void> uploadPdf() async {
    try {
      if (state.pdfBytes == null) return;
      emit(state.copyWith(status: ReportStatus.uploading));
      final id = const Uuid().v4();
      final filename = 'inspection_report_$id.pdf';
      final path = await ReportService.uploadPdf(state.pdfBytes!, filename);
      emit(state.copyWith(status: ReportStatus.uploaded, storagePath: path));
    } catch (e) {
      emit(
        state.copyWith(status: ReportStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> sendViaCloudFunction(String recipientEmail) async {
    try {
      if (state.storagePath == null) throw Exception('Upload the PDF first');
      emit(state.copyWith(status: ReportStatus.sending));
      final resp = await ReportService.sendReportViaCloudFunction(
        storagePath: state.storagePath!,
        to: recipientEmail,
      );
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        emit(state.copyWith(status: ReportStatus.sent));
      } else {
        emit(
          state.copyWith(
            status: ReportStatus.error,
            errorMessage:
                'Cloud function error ${resp.statusCode}: ${resp.body}',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ReportStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
