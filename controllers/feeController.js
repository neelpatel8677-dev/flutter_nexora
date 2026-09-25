const Fee = require('../models/Fee');

// @desc    Create fee record (Faculty/Admin)
// @route   POST /api/fees
// @access  Private/Faculty/Admin
exports.createFee = async (req, res) => {
  try {
    const fee = await Fee.create({
      ...req.body,
      createdBy: req.user._id,
    });

    res.status(201).json({
      success: true,
      message: 'Fee record created',
      data: fee,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get fees
// @route   GET /api/fees
// @access  Private
exports.getFees = async (req, res) => {
  try {
    let query = {};

    if (req.user.role === 'student') {
      query.student = req.user._id;
    } else if (req.query.studentId) {
      query.student = req.query.studentId;
    }

    if (req.query.status) query.status = req.query.status;

    const fees = await Fee.find(query)
      .populate('student', 'name studentId course')
      .populate('createdBy', 'name')
      .sort('-createdAt');

    const summary = {
      total: fees.reduce((sum, f) => sum + f.amount, 0),
      paid: fees.reduce((sum, f) => sum + (f.paidAmount || 0), 0),
      pending: fees
        .filter((f) => f.status === 'pending' || f.status === 'overdue')
        .reduce((sum, f) => sum + (f.amount - (f.paidAmount || 0)), 0),
    };

    res.json({
      success: true,
      count: fees.length,
      summary,
      data: fees,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update fee (mark paid etc)
// @route   PUT /api/fees/:id
// @access  Private/Faculty/Admin
exports.updateFee = async (req, res) => {
  try {
    let fee = await Fee.findById(req.params.id);

    if (!fee) {
      return res.status(404).json({ success: false, message: 'Fee not found' });
    }

    if (req.body.status === 'paid') {
      req.body.paidDate = new Date();
      req.body.paidAmount = req.body.paidAmount || fee.amount;
    }

    fee = await Fee.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.json({ success: true, data: fee });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete fee
// @route   DELETE /api/fees/:id
// @access  Private/Admin
exports.deleteFee = async (req, res) => {
  try {
    const fee = await Fee.findById(req.params.id);
    if (!fee) {
      return res.status(404).json({ success: false, message: 'Fee not found' });
    }
    await fee.deleteOne();
    res.json({ success: true, message: 'Fee deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
