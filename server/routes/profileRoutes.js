const express = require('express');
const router = express.Router();
const profileController = require('../controllers/profileController');

router.put('/update/:id', profileController.updateProfile);
router.put('/image/:id', profileController.updateProfilePicUrl);

module.exports = router;