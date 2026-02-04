const admin = require('../config/firebase');
const User = require('../modules/users/user.model');

module.exports = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'No token provided' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = await admin.auth().verifyIdToken(token);

    const uid = decoded.uid;
    if (!uid) {
      throw new Error('Invalid token payload: missing uid');
    }

    const upsertData = {
      firebaseUid: uid,
      uid, // لحل مشكلة الفهرس القديم uid_1 في القاعدة
      email: decoded.email,
      displayName: decoded.name || decoded.displayName,
      avatar: decoded.picture,
    };

    const user = await User.findOneAndUpdate(
      { $or: [{ firebaseUid: uid }, { uid }] },
      { $setOnInsert: upsertData },
      { new: true, upsert: true }
    );

    req.firebaseUser = decoded; // decoded Firebase token
    req.user = user;            // Mongo user
    return next();
  } catch (e) {
    console.error('Auth error:', e.message);
    return res.status(401).json({ message: 'Invalid token' });
  }
};
