const mongoose = require('mongoose');

const periodSchema = new mongoose.Schema({
  day: {
    type: String,
    enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    required: true,
  },
  startTime: {
    type: String,
    required: true, // e.g. "09:00"
  },
  endTime: {
    type: String,
    required: true, // e.g. "10:00"
  },
  subject: {
    type: String,
    required: true,
  },
  faculty: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  room: {
    type: String,
  },
});

const timetableSchema = new mongoose.Schema(
  {
    course: {
      type: String,
      required: true,
    },
    semester: {
      type: Number,
      required: true,
    },
    batch: {
      type: String,
    },
    periods: [periodSchema],
    academicYear: {
      type: String,
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Timetable', timetableSchema);
