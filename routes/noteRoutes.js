const express = require('express');
const router = express.Router();
const {
  createNote,
  getNotes,
  getNote,
  updateNote,
  deleteNote,
} = require('../controllers/noteController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getNotes);
router.get('/:id', getNote);
router.post('/', authorize('faculty', 'admin'), createNote);
router.put('/:id', authorize('faculty', 'admin'), updateNote);
router.delete('/:id', authorize('faculty', 'admin'), deleteNote);

module.exports = router;
