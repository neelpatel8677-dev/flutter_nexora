const express = require('express');
const router = express.Router();
const {
  createFee,
  getFees,
  updateFee,
  deleteFee,
} = require('../controllers/feeController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getFees);
router.post('/', authorize('faculty', 'admin'), createFee);
router.put('/:id', authorize('faculty', 'admin'), updateFee);
router.delete('/:id', authorize('admin'), deleteFee);

module.exports = router;
