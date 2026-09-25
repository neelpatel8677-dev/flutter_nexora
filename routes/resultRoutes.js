const express = require('express');
const router = express.Router();
const {
  createResult,
  getResults,
  updateResult,
  deleteResult,
} = require('../controllers/resultController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getResults);
router.post('/', authorize('faculty', 'admin'), createResult);
router.put('/:id', authorize('faculty', 'admin'), updateResult);
router.delete('/:id', authorize('admin'), deleteResult);

module.exports = router;
