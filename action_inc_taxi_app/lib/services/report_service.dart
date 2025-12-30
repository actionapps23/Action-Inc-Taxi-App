import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
// web-only import used to open preview in new tab
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class ReportService {
  static const String _reportsFolder = 'reports';
  // This is a placeholder Cloud Function URL which should be deployed by you.
  // The function should accept JSON: { "storagePath": "reports/xxx.pdf", "to": "email@domain" }
  static const String cloudFunctionUrl = '<YOUR_CLOUD_FUNCTION_URL_HERE>';

  /// Generate PDF bytes from table rows and app logo in assets/logo/
  static Future<Uint8List> generateReportPdf(
    List<Map<String, dynamic>> rows,
  ) async {
    final pdf = pw.Document();

    // try load logo asset
    Uint8List? logoBytes;
    try {
      logoBytes = (await rootBundle.load(
        'assets/logo/logo.png',
      )).buffer.asUint8List();
    } catch (_) {
      // ignore if logo not found
      logoBytes = null;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (logoBytes != null)
                  pw.Image(pw.MemoryImage(logoBytes), width: 80, height: 80),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ACTIONINC TRANSPORT CARRIER CORP.',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headers: [
                'Date',
                'Plate Number',
                'Vehicle Model / Type',
                'Driver Name',
                'Cleanliness',
                'Remarks',
              ],
              data: rows
                  .map(
                    (r) => [
                      r['date'] ?? '',
                      r['plateNumber'] ?? '',
                      r['vehicleModel'] ?? '',
                      r['driverName'] ?? '',
                      r['cleanliness'] ?? '',
                      r['remarks'] ?? '',
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              columnWidths: {
                0: pw.FixedColumnWidth(60),
                1: pw.FixedColumnWidth(70),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(1.5),
                4: pw.FixedColumnWidth(70),
                5: pw.FlexColumnWidth(3),
              },
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Upload PDF bytes to Firebase Storage. Returns the storage path (not public URL).
  static Future<String> uploadPdf(Uint8List bytes, String filename) async {
    final ref = FirebaseStorage.instance.ref().child(
      '$_reportsFolder/$filename',
    );
    final metadata = SettableMetadata(contentType: 'application/pdf');
    await ref.putData(bytes, metadata);
    // return the storage path for the cloud function to fetch
    return '$_reportsFolder/$filename';
  }

  /// Calls your Cloud Function endpoint to send the report via AWS SES.
  /// The function is expected to fetch the file from Firebase Storage and send it.
  static Future<http.Response> sendReportViaCloudFunction({
    required String storagePath,
    required String to,
    String subject = 'Inspection Report',
    String body = 'Please find attached inspection report.',
  }) async {
    if (cloudFunctionUrl.contains('<YOUR_CLOUD_FUNCTION_URL_HERE>')) {
      throw Exception(
        'cloudFunctionUrl not configured. Set ReportService.cloudFunctionUrl',
      );
    }

    final payload = {
      'storagePath': storagePath,
      'to': to,
      'subject': subject,
      'body': body,
    };

    final uri = Uri.parse(cloudFunctionUrl);
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    return resp;
  }

  /// Preview PDF in browser (web-only). Uses `dart:html` to open a blob URL.
  static Future<void> previewPdf(
    Uint8List bytes, {
    String filename = 'report.pdf',
  }) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }
}
