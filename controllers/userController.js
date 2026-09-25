const User = require('../models/User');

// @desc    Get all users (Admin)
// @route   GET /api/users
// @access  Private/Admin
exports.getUsers = async (req, res) => {
  try {
    const { role, search } = req.query;
    let query = {};

    if (role) query.role = role;
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } },
        { studentId: { $regex: search, $options: 'i' } },
        { employeeId: { $regex: search, $options: 'i' } },
      ];
    }

    const users = await User.find(query).select('-password').sort('-createdAt');

    res.json({
      success: true,
      count: users.length,
      data: users,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get single user
// @route   GET /api/users/:id
// @access  Private
exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.json({ success: true, data: user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update user (Admin or self)
// @route   PUT /api/users/:id
// @access  Private
exports.updateUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Only admin or the user themselves can update
    if (req.user.role !== 'admin' && req.user._id.toString() !== req.params.id) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    const fields = ['name', 'phone', 'course', 'semester', 'batch', 'department', 'subjects'];
    fields.forEach((field) => {
      if (req.body[field] !== undefined) user[field] = req.body[field];
    });

    // Only admin can change isActive and role
    if (req.user.role === 'admin') {
      if (req.body.isActive !== undefined) user.isActive = req.body.isActive;
    }

    await user.save();

    res.json({
      success: true,
      message: 'User updated',
      data: user,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete / deactivate user (Admin)
// @route   DELETE /api/users/:id
// @access  Private/Admin
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    if (user.role === 'admin') {
      return res.status(400).json({ success: false, message: 'Cannot delete admin' });
    }

    // Soft delete
    user.isActive = false;
    await user.save();

    res.json({ success: true, message: 'User deactivated' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get students by course/semester (Faculty/Admin)
// @route   GET /api/users/students
// @access  Private/Faculty/Admin
exports.getStudents = async (req, res) => {
  try {
    const { course, semester, batch } = req.query;
    let query = { role: 'student', isActive: true };

    if (course) query.course = course;
    if (semester) query.semester = Number(semester);
    if (batch) query.batch = batch;

    const students = await User.find(query).select('-password').sort('name');

    res.json({
      success: true,
      count: students.length,
      data: students,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
