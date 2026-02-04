const router = require('express').Router();
const controller = require('./news.controller');
const auth = require('../../middlewares/auth.middleware');

// Public feed of all news
router.get('/', controller.getAllNews);

// Authenticated users can publish news
router.post('/', auth, controller.createNews);

module.exports = router;
