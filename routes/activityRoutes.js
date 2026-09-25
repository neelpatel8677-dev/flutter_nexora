const express = require('express');
const router = express.Router();
const {
  createActivity,
  getActivities,
  updateActivity,
  deleteActivity,
} = require('../controllers/activityController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getActivities);
router.post('/', authorize('faculty', 'admin'), createActivity);
router.put('/:id', updateActivity);
router.delete('/:id', authorize('faculty', 'admin'), deleteActivity);

module.exports = router;
