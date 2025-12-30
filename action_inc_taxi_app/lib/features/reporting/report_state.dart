import 'dart:typed_data';

import 'models/report_row.dart';

enum ReportStatus { initial, generating, ready, uploading, uploaded, sending, sent, error }

class ReportState {
  final List<ReportRow> rows;
  final ReportStatus status;
  final Uint8List? pdfBytes;
  final String? storagePath;
  final String? errorMessage;

  ReportState({
    required this.rows,
    required this.status,
    this.pdfBytes,
    this.storagePath,
    this.errorMessage,
  });

  factory ReportState.initial() => ReportState(rows: [], status: ReportStatus.initial);

  ReportState copyWith({
    List<ReportRow>? rows,
    ReportStatus? status,
    Uint8List? pdfBytes,
    String? storagePath,
    String? errorMessage,
  }) {
    return ReportState(
      rows: rows ?? this.rows,
      status: status ?? this.status,
      pdfBytes: pdfBytes ?? this.pdfBytes,
      storagePath: storagePath ?? this.storagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
