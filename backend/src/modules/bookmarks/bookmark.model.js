const mongoose = require('mongoose');
const bookmarkSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    newsUrl: { type: String, required: true },
    title: String,
    image: String,
    source: String,
    publishedAt: Date,
  },
  { timestamps: true }
);

bookmarkSchema.index({ user: 1, newsUrl: 1 }, { unique: true });

module.exports = mongoose.model('Bookmark', bookmarkSchema);


