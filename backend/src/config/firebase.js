const admin = require('firebase-admin');

// Prefer env-based credentials for deployment (Render/Vercel/etc).
// - FIREBASE_SERVICE_ACCOUNT: JSON string of the service account
// - FIREBASE_SERVICE_ACCOUNT_PATH: path to a service account json file (local/dev)
function loadCredential() {
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    try {
      const json = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
      return admin.credential.cert(json);
    } catch (e) {
      throw new Error(
        'Invalid FIREBASE_SERVICE_ACCOUNT JSON. Make sure it is valid JSON (not base64).',
      );
    }
  }

  if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH) {
    // eslint-disable-next-line global-require, import/no-dynamic-require
    const json = require(process.env.FIREBASE_SERVICE_ACCOUNT_PATH);
    return admin.credential.cert(json);
  }

  // Fallback to local file (NOT for git / production).
  // eslint-disable-next-line global-require
  const serviceAccount = require('../../news-app-df700-firebase-adminsdk-fbsvc-17b295687b.json');
  return admin.credential.cert(serviceAccount);
}

if (!admin.apps.length) {
  admin.initializeApp({
    credential: loadCredential(),
  });
}

module.exports = admin;
