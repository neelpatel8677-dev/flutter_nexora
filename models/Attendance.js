const mongoose = require('mongoose');

const attendanceSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    faculty: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    subject: {
      type: String,
      required: true,
    },
    date: {
      type: Date,
      required: true,
    },
    status: {
      type: String,
      enum: ['present', 'absent', 'late'],
      required: true,
    },
    lectureNumber: {
      type: Number,
      default: 1,
    },
    semester: {
      type: Number,
    },
    remarks: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

// Compound index to prevent duplicate attendance for same student+subject+date+lecture
attendanceSchema.index(
  { student: 1, subject: 1, date: 1, lectureNumber: 1 },
  { unique: true }
);

module.exports = mongoose.model('Attendance', attendanceSchema);
