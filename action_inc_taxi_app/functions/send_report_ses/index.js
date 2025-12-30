const { Storage } = require('@google-cloud/storage');
const AWS = require('aws-sdk');
const nodemailer = require('nodemailer');

// Environment variables expected:
// GCLOUD_STORAGE_BUCKET - bucket name where reports are uploaded
// AWS_REGION
// AWS_ACCESS_KEY_ID
// AWS_SECRET_ACCESS_KEY
// EMAIL_FROM - the verified sender email in SES

const storage = new Storage();

exports.sendReport = async (req, res) => {
  try {
    if (req.method !== 'POST') return res.status(405).send('Method Not Allowed');
    const { storagePath, to, subject = 'Inspection Report', body = 'Please find attached inspection report.' } = req.body;
    if (!storagePath || !to) return res.status(400).send('storagePath and to are required');

    const bucketName = process.env.GCLOUD_STORAGE_BUCKET;
    if (!bucketName) return res.status(500).send('GCLOUD_STORAGE_BUCKET not configured');

    // download file
    const file = storage.bucket(bucketName).file(storagePath);
    const [buffer] = await file.download();

    // configure AWS
    AWS.config.update({ region: process.env.AWS_REGION });

    // create nodemailer transporter using AWS SES
    const transporter = nodemailer.createTransport({
      SES: new AWS.SES({ apiVersion: '2010-12-01' })
    });

    const mail = {
      from: process.env.EMAIL_FROM,
      to,
      subject,
      text: body,
      attachments: [
        {
          filename: 'inspection_report.pdf',
          content: buffer,
          contentType: 'application/pdf'
        }
      ]
    };

    const info = await transporter.sendMail(mail);

    return res.status(200).send({ message: 'Email sent', info });
  } catch (err) {
    console.error(err);
    return res.status(500).send({ error: err.message });
  }
};
