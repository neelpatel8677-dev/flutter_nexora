const Timetable = require('../models/Timetable');

// @desc    Create timetable (Faculty/Admin)
// @route   POST /api/timetable
// @access  Private/Faculty/Admin
exports.createTimetable = async (req, res) => {
  try {
    const timetable = await Timetable.create({
      ...req.body,
      createdBy: req.user._id,
    });

    res.status(201).json({
      success: true,
      message: 'Timetable created',
      data: timetable,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get timetable
// @route   GET /api/timetable
// @access  Private
exports.getTimetable = async (req, res) => {
  try {
    let query = {};

    if (req.user.role === 'student') {
      query.course = req.user.course;
      query.semester = req.user.semester;
      if (req.user.batch) query.batch = req.user.batch;
    } else {
      if (req.query.course) query.course = req.query.course;
      if (req.query.semester) query.semester = Number(req.query.semester);
      if (req.query.batch) query.batch = req.query.batch;
    }

    const timetables = await Timetable.find(query)
      .populate('periods.faculty', 'name employeeId')
      .populate('createdBy', 'name')
      .sort('-createdAt');

    res.json({
      success: true,
      count: timetables.length,
      data: timetables,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update timetable
// @route   PUT /api/timetable/:id
// @access  Private/Faculty/Admin
exports.updateTimetable = async (req, res) => {
  try {
    let timetable = await Timetable.findById(req.params.id);

    if (!timetable) {
      return res.status(404).json({ success: false, message: 'Timetable not found' });
    }

    timetable = await Timetable.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    }).populate('periods.faculty', 'name');

    res.json({ success: true, data: timetable });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete timetable
// @route   DELETE /api/timetable/:id
// @access  Private/Admin
exports.deleteTimetable = async (req, res) => {
  try {
    const timetable = await Timetable.findById(req.params.id);
    if (!timetable) {
      return res.status(404).json({ success: false, message: 'Timetable not found' });
    }
    await timetable.deleteOne();
    res.json({ success: true, message: 'Timetable deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
