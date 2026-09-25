const User = require('../models/User');
const generateToken = require('../utils/generateToken');

// @desc    Register student or faculty
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  try {
    const {
      name,
      email,
      password,
      role,
      phone,
      studentId,
      course,
      semester,
      batch,
      employeeId,
      department,
      subjects,
    } = req.body;

    // Only allow student or faculty registration
    if (!['student', 'faculty'].includes(role)) {
      return res.status(400).json({
        success: false,
        message: 'Only students and faculty can register. Admin is fixed.',
      });
    }

    // Check if user exists
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({
        success: false,
        message: 'User already exists with this email',
      });
    }

    // Create user
    const userData = {
      name,
      email,
      password,
      role,
      phone,
    };

    if (role === 'student') {
      if (!studentId || !course) {
        return res.status(400).json({
          success: false,
          message: 'Student ID and course are required for students',
        });
      }
      userData.studentId = studentId;
      userData.course = course;
      userData.semester = semester || 1;
      userData.batch = batch;
    }

    if (role === 'faculty') {
      if (!employeeId || !department) {
        return res.status(400).json({
          success: false,
          message: 'Employee ID and department are required for faculty',
        });
      }
      userData.employeeId = employeeId;
      userData.department = department;
      userData.subjects = subjects || [];
    }

    const user = await User.create(userData);

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      data: {
        _id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        token: generateToken(user._id),
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: error.message || 'Server error',
    });
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email and password',
      });
    }

    const user = await User.findOne({ email }).select('+password');

    if (!user || !(await user.matchPassword(password))) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Your account has been deactivated. Contact admin.',
      });
    }

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        _id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        studentId: user.studentId,
        employeeId: user.employeeId,
        course: user.course,
        semester: user.semester,
        department: user.department,
        token: generateToken(user._id),
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Get current logged in user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    res.json({
      success: true,
      data: user,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};
