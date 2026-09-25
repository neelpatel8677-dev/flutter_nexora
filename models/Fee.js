const mongoose = require('mongoose');

const feeSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    amount: {
      type: Number,
      required: true,
    },
    feeType: {
      type: String,
      enum: ['tuition', 'exam', 'library', 'hostel', 'other'],
      default: 'tuition',
    },
    semester: {
      type: Number,
    },
    dueDate: {
      type: Date,
      required: true,
    },
    paidDate: {
      type: Date,
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'overdue', 'partial'],
      default: 'pending',
    },
    paidAmount: {
      type: Number,
      default: 0,
    },
    transactionId: {
      type: String,
    },
    remarks: {
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

module.exports = mongoose.model('Fee', feeSchema);
