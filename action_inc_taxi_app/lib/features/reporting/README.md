Reporting feature

Files added:
- `report_page.dart` - UI to enter multiple rows, preview, upload and send.
- `models/report_row.dart` - model for a single row.
- `report_cubit.dart` / `report_state.dart` - cubit to manage state and PDF lifecycle.
- `lib/services/report_service.dart` - generates PDF, uploads to Firebase Storage and calls Cloud Function.

Setup notes:
1. Update `lib/services/report_service.dart` and set `ReportService.cloudFunctionUrl` to your deployed Cloud Function URL (see functions/send_report_ses/README.md for sample function).
2. Deploy the Cloud Function and set environment variables for AWS SES and `GCLOUD_STORAGE_BUCKET`.
3. Make sure `assets/logo/logo.png` exists (or update the path in `report_service.dart`) so the PDF includes your company logo.
4. Run `flutter pub get`.

Usage:
- The report page is registered at route `/report`. You can navigate to it in app by `Navigator.pushNamed(context, '/report')` after login.

Cloud Function details are provided in `functions/send_report_ses/README.md`.
