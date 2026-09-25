const Note = require('../models/Note');

// @desc    Upload note (Faculty/Admin)
// @route   POST /api/notes
// @access  Private/Faculty/Admin
exports.createNote = async (req, res) => {
  try {
    const note = await Note.create({
      ...req.body,
      uploadedBy: req.user._id,
    });

    res.status(201).json({
      success: true,
      message: 'Note uploaded',
      data: note,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get notes
// @route   GET /api/notes
// @access  Private
exports.getNotes = async (req, res) => {
  try {
    let query = { isPublic: true };

    if (req.query.subject) query.subject = req.query.subject;
    if (req.query.semester) query.semester = Number(req.query.semester);
    if (req.query.department) query.department = req.query.department;

    // Faculty/Admin can see their own private notes too
    if (req.user.role !== 'student') {
      query = {
        $or: [{ isPublic: true }, { uploadedBy: req.user._id }],
      };
      if (req.query.subject) query.subject = req.query.subject;
    }

    const notes = await Note.find(query)
      .populate('uploadedBy', 'name department')
      .sort('-createdAt');

    res.json({
      success: true,
      count: notes.length,
      data: notes,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get single note
// @route   GET /api/notes/:id
// @access  Private
exports.getNote = async (req, res) => {
  try {
    const note = await Note.findById(req.params.id).populate(
      'uploadedBy',
      'name department'
    );

    if (!note) {
      return res.status(404).json({ success: false, message: 'Note not found' });
    }

    res.json({ success: true, data: note });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update note
// @route   PUT /api/notes/:id
// @access  Private/Faculty/Admin
exports.updateNote = async (req, res) => {
  try {
    let note = await Note.findById(req.params.id);

    if (!note) {
      return res.status(404).json({ success: false, message: 'Note not found' });
    }

    if (
      req.user.role !== 'admin' &&
      note.uploadedBy.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    note = await Note.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.json({ success: true, data: note });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete note
// @route   DELETE /api/notes/:id
// @access  Private/Faculty/Admin
exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findById(req.params.id);

    if (!note) {
      return res.status(404).json({ success: false, message: 'Note not found' });
    }

    if (
      req.user.role !== 'admin' &&
      note.uploadedBy.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    await note.deleteOne();
    res.json({ success: true, message: 'Note deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
