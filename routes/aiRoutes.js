const express = require('express');
const router = express.Router();
const { askAI } = require('../controllers/aiController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);
router.post('/ask', authorize('student'), askAI);

module.exports = router;
