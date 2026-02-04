const News = require('./news.model');

exports.createNews = async (req, res) => {
  try {
    const news = await News.create({
      ...req.body,
      userId: req.user.uid,
    });

    res.status(201).json(news);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

exports.getAllNews = async (req, res) => {
  const news = await News.find().sort({ createdAt: -1 });
  res.json(news);
};
