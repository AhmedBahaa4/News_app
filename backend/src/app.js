const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/news', require('./modules/news/news.routes'));
app.use('/api/users', require('./modules/users/user.routes'));
app.use('/api/bookmarks', require('./modules/bookmarks/bookmark.routes'));

app.get('/', (req, res) => {
  res.send('News API is running 🚀');
});

module.exports = app;
