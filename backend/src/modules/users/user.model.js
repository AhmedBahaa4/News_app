const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    firebaseUid: { type: String, required: true, unique: true },
    // احتفظ بحقل uid القديم لو كان هناك فهرس unique قائم بالفعل في قاعدة البيانات
    uid: { type: String, unique: true, sparse: true },
    email: { type: String, required: true },
    displayName: String,
    avatar: String,
    role: { type: String, default: 'user' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('User', userSchema);
