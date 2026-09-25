const express = require('express');
const router = express.Router();
const {
  createTimetable,
  getTimetable,
  updateTimetable,
  deleteTimetable,
} = require('../controllers/timetableController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getTimetable);
router.post('/', authorize('faculty', 'admin'), createTimetable);
router.put('/:id', authorize('faculty', 'admin'), updateTimetable);
router.delete('/:id', authorize('admin'), deleteTimetable);

module.exports = router;
