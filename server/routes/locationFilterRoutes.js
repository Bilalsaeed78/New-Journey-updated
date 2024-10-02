const express = require('express');
const router = express.Router();
const locationFilterController = require('../controllers/locationFilterController');

router.post('/location', locationFilterController.filterPropertiesByDistance);

module.exports = router;