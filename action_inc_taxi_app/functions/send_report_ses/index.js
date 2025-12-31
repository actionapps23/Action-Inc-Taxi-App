const { onRequest } = require("firebase-functions/v2/https");
const { Storage } = require("@google-cloud/storage");
const sgMail = require("@sendgrid/mail");
const functions = require("firebase-functions");

const storage = new Storage();

exports.sendReport = onRequest(async (req, res) => {
  // ✅ Set CORS headers first
  res.set('Access-Control-Allow-Origin', '*');
  res.set(
    'Access-Control-Allow-Headers',
    'Content-Type, x-api-key, Authorization'
  );
  res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');

  // Handle preflight OPTIONS request
  if (req.method === 'OPTIONS') {
    return res.status(204).send('');
  }

  try {
    // Only POST requests
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    // Check secret API key
    const secret = req.headers["x-api-key"];
    const configuredKey = process.env.SENDREPORT_KEY || functions.config().sendreport.key;
    if (!secret || secret !== configuredKey) {
      return res.status(401).send({ error: "Unauthorized" });
    }

    // Read request body
    const { storagePath, to, subject = "Inspection Report", body = "Please find attached inspection report." } = req.body;
    if (!storagePath || !to) {
      return res.status(400).send({ error: "storagePath and to are required" });
    }

    // Use your bucket
    const bucketName = process.env.GCLOUD_STORAGE_BUCKET || functions.config().gcloud.bucket;
    const file = storage.bucket(bucketName).file(storagePath);
    const [buffer] = await file.download();

    // Configure SendGrid
    const sendgridKey = process.env.SENDGRID_API_KEY || functions.config().sendgrid.key;
    if (!sendgridKey) {
      return res.status(500).send({ error: "SENDGRID_API_KEY not configured" });
    }
    sgMail.setApiKey(sendgridKey);

    const msg = {
      to,
      from: process.env.EMAIL_FROM || functions.config().email.from,
      subject,
      text: body,
      attachments: [
        {
          content: buffer.toString("base64"),
          filename: "inspection_report.pdf",
          type: "application/pdf",
          disposition: "attachment",
        },
      ],
    };

    const [response] = await sgMail.send(msg);

    return res.status(200).send({
      message: "Email sent via SendGrid",
      statusCode: response.statusCode,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).send({ error: err.message });
  }
});
