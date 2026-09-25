const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
    },
    type: {
      type: String,
      enum: ['assignment', 'project', 'event', 'extracurricular', 'other'],
      default: 'other',
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'in-progress'],
      default: 'pending',
    },
    dueDate: {
      type: Date,
    },
    completedDate: {
      type: Date,
    },
    marks: {
      type: Number,
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

module.exports = mongoose.model('Activity', activitySchema);
