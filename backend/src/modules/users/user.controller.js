const User = require('./user.model');

exports.getOrCreateUser = async (req, res) => {
  try {
    // auth middleware سبق وأنشأ أو استرجع المستخدم
    return res.json(req.user);
  } catch (err) {
    console.error('User Controller Error:', err.message);
    res.status(500).json({ message: err.message });
  }
};

// PATCH /users/me -> update name / avatar
exports.updateMe = async (req, res) => {
  try {
    const { name, avatar } = req.body;
    if (name) req.user.displayName = name;
    if (avatar) req.user.avatar = avatar;
    await req.user.save();
    return res.json(req.user);
  } catch (err) {
    console.error('User update error:', err.message);
    res.status(500).json({ message: err.message });
  }
};
