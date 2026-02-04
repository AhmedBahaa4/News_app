const router = require('express').Router();
const controller = require('./bookmark.controller');
const auth = require('../../middlewares/auth.middleware');
router.post('/', auth, controller.addBookmark);
router.delete('/', auth, controller.removeBookmark);

router.get('/', auth, controller.getMyBookmarks);


module.exports = router;
