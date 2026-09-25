const mongoose = require('mongoose');

const subjectResultSchema = new mongoose.Schema({
  subject: {
    type: String,
    required: true,
  },
  marksObtained: {
    type: Number,
    required: true,
  },
  maxMarks: {
    type: Number,
    default: 100,
  },
  grade: {
    type: String,
  },
});

const resultSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    semester: {
      type: Number,
      required: true,
    },
    examType: {
      type: String,
      enum: ['midterm', 'final', 'internal', 'practical'],
      default: 'final',
    },
    subjects: [subjectResultSchema],
    totalMarks: {
      type: Number,
    },
    percentage: {
      type: Number,
    },
    cgpa: {
      type: Number,
    },
    rank: {
      type: Number,
    },
    uploadedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Result', resultSchema);
