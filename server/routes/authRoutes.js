const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.register);
router.post('/authenticate', authController.authenticate);
router.get('/current/:id', authController.getUserInfo);

module.exports = router;
