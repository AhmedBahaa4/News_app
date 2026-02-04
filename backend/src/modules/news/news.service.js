const getAllNews = async () => {
  const news = await News.find().sort({ createdAt: -1 });
  return news;
};

module.exports = {
  getAllNews,
};
