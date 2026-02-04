const mongoose = require('mongoose');

const newsSchema = new mongoose.Schema(
  {
    title: String,
    content: String,
    userId: String,
  },
  { timestamps: true }
);

module.exports = mongoose.model('News', newsSchema);
