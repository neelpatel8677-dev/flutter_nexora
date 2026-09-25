const Activity = require('../models/Activity');

// @desc    Create activity (Faculty/Admin)
// @route   POST /api/activities
// @access  Private/Faculty/Admin
exports.createActivity = async (req, res) => {
  try {
    const activity = await Activity.create({
      ...req.body,
      createdBy: req.user._id,
    });

    res.status(201).json({
      success: true,
      message: 'Activity created',
      data: activity,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get activities
// @route   GET /api/activities
// @access  Private
exports.getActivities = async (req, res) => {
  try {
    let query = {};

    if (req.user.role === 'student') {
      query.student = req.user._id;
    } else if (req.query.studentId) {
      query.student = req.query.studentId;
    }

    if (req.query.status) query.status = req.query.status;
    if (req.query.type) query.type = req.query.type;

    const activities = await Activity.find(query)
      .populate('student', 'name studentId')
      .populate('createdBy', 'name')
      .sort('-createdAt');

    res.json({
      success: true,
      count: activities.length,
      data: activities,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update activity
// @route   PUT /api/activities/:id
// @access  Private
exports.updateActivity = async (req, res) => {
  try {
    let activity = await Activity.findById(req.params.id);

    if (!activity) {
      return res.status(404).json({ success: false, message: 'Activity not found' });
    }

    // Student can only update their own status
    if (req.user.role === 'student') {
      if (activity.student.toString() !== req.user._id.toString()) {
        return res.status(403).json({ success: false, message: 'Not authorized' });
      }
      // Students can only update status
      if (req.body.status) {
        activity.status = req.body.status;
        if (req.body.status === 'completed') {
          activity.completedDate = new Date();
        }
        await activity.save();
      }
    } else {
      activity = await Activity.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true,
      });
    }

    res.json({ success: true, data: activity });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete activity
// @route   DELETE /api/activities/:id
// @access  Private/Faculty/Admin
exports.deleteActivity = async (req, res) => {
  try {
    const activity = await Activity.findById(req.params.id);
    if (!activity) {
      return res.status(404).json({ success: false, message: 'Activity not found' });
    }
    await activity.deleteOne();
    res.json({ success: true, message: 'Activity deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
