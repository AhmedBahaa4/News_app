const router = require('express').Router();
const controller = require('./user.controller');
const auth = require('../../middlewares/auth.middleware');

router.get('/me', auth, controller.getOrCreateUser);
router.patch('/me', auth, controller.updateMe);

module.exports = router;
