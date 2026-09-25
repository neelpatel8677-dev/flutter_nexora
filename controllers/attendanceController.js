const Attendance = require('../models/Attendance');
const User = require('../models/User');

// @desc    Mark attendance (Faculty)
// @route   POST /api/attendance
// @access  Private/Faculty
exports.markAttendance = async (req, res) => {
  try {
    const { studentId, subject, date, status, lectureNumber, semester, remarks } = req.body;

    const student = await User.findById(studentId);
    if (!student || student.role !== 'student') {
      return res.status(404).json({ success: false, message: 'Student not found' });
    }

    const attendance = await Attendance.create({
      student: studentId,
      faculty: req.user._id,
      subject,
      date: date || new Date(),
      status,
      lectureNumber: lectureNumber || 1,
      semester: semester || student.semester,
      remarks,
    });

    res.status(201).json({
      success: true,
      message: 'Attendance marked',
      data: attendance,
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Attendance already marked for this lecture',
      });
    }
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Bulk mark attendance
// @route   POST /api/attendance/bulk
// @access  Private/Faculty
exports.bulkMarkAttendance = async (req, res) => {
  try {
    const { records, subject, date, lectureNumber, semester } = req.body;

    if (!records || !Array.isArray(records) || records.length === 0) {
      return res.status(400).json({ success: false, message: 'Records array required' });
    }

    const results = [];
    for (const rec of records) {
      try {
        const att = await Attendance.create({
          student: rec.studentId,
          faculty: req.user._id,
          subject,
          date: date || new Date(),
          status: rec.status,
          lectureNumber: lectureNumber || 1,
          semester,
          remarks: rec.remarks,
        });
        results.push({ success: true, data: att });
      } catch (err) {
        results.push({
          success: false,
          studentId: rec.studentId,
          message: err.code === 11000 ? 'Already marked' : err.message,
        });
      }
    }

    res.status(201).json({
      success: true,
      message: 'Bulk attendance processed',
      data: results,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get student attendance (Student sees own, Faculty/Admin see all)
// @route   GET /api/attendance
// @access  Private
exports.getAttendance = async (req, res) => {
  try {
    let query = {};

    if (req.user.role === 'student') {
      query.student = req.user._id;
    } else if (req.query.studentId) {
      query.student = req.query.studentId;
    }

    if (req.query.subject) query.subject = req.query.subject;
    if (req.query.semester) query.semester = Number(req.query.semester);

    const attendance = await Attendance.find(query)
      .populate('student', 'name studentId course semester')
      .populate('faculty', 'name employeeId')
      .sort('-date');

    // Calculate summary if student
    let summary = null;
    if (req.user.role === 'student' || req.query.studentId) {
      const total = attendance.length;
      const present = attendance.filter((a) => a.status === 'present').length;
      const absent = attendance.filter((a) => a.status === 'absent').length;
      const late = attendance.filter((a) => a.status === 'late').length;
      summary = {
        total,
        present,
        absent,
        late,
        percentage: total > 0 ? ((present + late * 0.5) / total * 100).toFixed(2) : 0,
      };
    }

    res.json({
      success: true,
      count: attendance.length,
      summary,
      data: attendance,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get lecture-wise attendance for a subject
// @route   GET /api/attendance/lecture-wise
// @access  Private
exports.getLectureWise = async (req, res) => {
  try {
    const { subject, studentId } = req.query;
    let query = {};

    if (req.user.role === 'student') {
      query.student = req.user._id;
    } else if (studentId) {
      query.student = studentId;
    }

    if (subject) query.subject = subject;

    const attendance = await Attendance.find(query)
      .populate('student', 'name studentId')
      .sort('date lectureNumber');

    // Group by subject
    const grouped = {};
    attendance.forEach((a) => {
      if (!grouped[a.subject]) grouped[a.subject] = [];
      grouped[a.subject].push({
        date: a.date,
        lectureNumber: a.lectureNumber,
        status: a.status,
        remarks: a.remarks,
      });
    });

    res.json({
      success: true,
      data: grouped,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update attendance
// @route   PUT /api/attendance/:id
// @access  Private/Faculty
exports.updateAttendance = async (req, res) => {
  try {
    let attendance = await Attendance.findById(req.params.id);

    if (!attendance) {
      return res.status(404).json({ success: false, message: 'Attendance not found' });
    }

    // Only the faculty who marked it or admin can update
    if (
      req.user.role !== 'admin' &&
      attendance.faculty.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    attendance = await Attendance.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.json({ success: true, data: attendance });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
