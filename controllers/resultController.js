const Result = require('../models/Result');

// @desc    Upload / create result (Faculty/Admin)
// @route   POST /api/results
// @access  Private/Faculty/Admin
exports.createResult = async (req, res) => {
  try {
    const { student, semester, examType, subjects } = req.body;

    // Calculate totals
    let totalMarks = 0;
    let maxTotal = 0;
    subjects.forEach((s) => {
      totalMarks += s.marksObtained;
      maxTotal += s.maxMarks || 100;
      // Simple grade
      const pct = (s.marksObtained / (s.maxMarks || 100)) * 100;
      if (pct >= 90) s.grade = 'A+';
      else if (pct >= 80) s.grade = 'A';
      else if (pct >= 70) s.grade = 'B+';
      else if (pct >= 60) s.grade = 'B';
      else if (pct >= 50) s.grade = 'C';
      else if (pct >= 40) s.grade = 'D';
      else s.grade = 'F';
    });

    const percentage = maxTotal > 0 ? (totalMarks / maxTotal) * 100 : 0;
    const cgpa = (percentage / 9.5).toFixed(2); // Approximate

    const result = await Result.create({
      student,
      semester,
      examType,
      subjects,
      totalMarks,
      percentage: percentage.toFixed(2),
      cgpa,
      uploadedBy: req.user._id,
    });

    res.status(201).json({
      success: true,
      message: 'Result uploaded',
      data: result,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get results
// @route   GET /api/results
// @access  Private
exports.getResults = async (req, res) => {
  try {
    let query = {};

    if (req.user.role === 'student') {
      query.student = req.user._id;
    } else if (req.query.studentId) {
      query.student = req.query.studentId;
    }

    if (req.query.semester) query.semester = Number(req.query.semester);

    const results = await Result.find(query)
      .populate('student', 'name studentId course semester')
      .populate('uploadedBy', 'name')
      .sort('-semester');

    res.json({
      success: true,
      count: results.length,
      data: results,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update result
// @route   PUT /api/results/:id
// @access  Private/Faculty/Admin
exports.updateResult = async (req, res) => {
  try {
    let result = await Result.findById(req.params.id);
    if (!result) {
      return res.status(404).json({ success: false, message: 'Result not found' });
    }

    result = await Result.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.json({ success: true, data: result });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete result
// @route   DELETE /api/results/:id
// @access  Private/Admin
exports.deleteResult = async (req, res) => {
  try {
    const result = await Result.findById(req.params.id);
    if (!result) {
      return res.status(404).json({ success: false, message: 'Result not found' });
    }
    await result.deleteOne();
    res.json({ success: true, message: 'Result deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
