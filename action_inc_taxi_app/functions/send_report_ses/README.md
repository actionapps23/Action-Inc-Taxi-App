# send_report_ses Cloud Function

This is a sample Google Cloud Function (HTTP) that downloads a PDF from Google Cloud Storage and sends it via AWS SES using nodemailer.

Environment variables required:
- `GCLOUD_STORAGE_BUCKET` - the GCS bucket name where reports are uploaded
- `AWS_REGION` - AWS region for SES
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` - AWS credentials (use IAM user with SES send permissions)
- `EMAIL_FROM` - verified SES sender email

Deploy (gcloud):

```bash
cd functions/send_report_ses
npm install

gcloud functions deploy sendReport \
  --runtime nodejs18 \
  --trigger-http \
  --allow-unauthenticated \
  --set-env-vars "GCLOUD_STORAGE_BUCKET=your-bucket,AWS_REGION=us-east-1,EMAIL_FROM=sender@domain.com"
```

Make sure to set AWS credentials in the function's runtime environment via Secret Manager or environment variables (be careful with secrets in env vars).

Usage (from Flutter web): call the Cloud Function URL with POST JSON:

```json
{
  "storagePath": "reports/inspection_report_xxx.pdf",
  "to": "recipient@example.com",
  "subject": "Inspection report",
  "body": "See attached"
}
```
