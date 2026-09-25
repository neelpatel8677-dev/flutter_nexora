const express = require('express');
const router = express.Router();
const {
  markAttendance,
  bulkMarkAttendance,
  getAttendance,
  getLectureWise,
  updateAttendance,
} = require('../controllers/attendanceController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getAttendance);
router.get('/lecture-wise', getLectureWise);
router.post('/', authorize('faculty', 'admin'), markAttendance);
router.post('/bulk', authorize('faculty', 'admin'), bulkMarkAttendance);
router.put('/:id', authorize('faculty', 'admin'), updateAttendance);

module.exports = router;
