const Bookmark = require('./bookmark.model');

exports.addBookmark = async (req, res) => {
  try {
    const bookmark = await Bookmark.create({
      user: req.user._id,
      newsUrl: req.body.newsUrl || req.body.url, // دعم الاثنين
      title: req.body.title,
      image: req.body.urlToImage,
      source: req.body.source,
      publishedAt: req.body.publishedAt,
    });
    res.status(201).json(bookmark);
  } catch (e) {
    if (e.code === 11000) {
      // اجعل العملية idempotent: لو مكرر رجع نجاح بدل خطأ
      return res.status(200).json({ message: 'Already bookmarked' });
    }
    res.status(400).json({ error: e.message });
  }
};

exports.removeBookmark = async (req, res) => {
  await Bookmark.findOneAndDelete({
    user: req.user._id,
    newsUrl: req.body.newsUrl || req.body.url, // نفس المفتاح
  });
  res.json({ message: 'Bookmark removed' });
};

// Get current user's bookmarks
exports.getMyBookmarks = async (req, res) => {
  const bookmarks = await Bookmark.find({ user: req.user._id }).sort({
    createdAt: -1,
  });
  res.json(bookmarks);
};
