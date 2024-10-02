const express = require('express');
const router = express.Router();
const propertyController = require('../controllers/propertyController');

router.post('/', propertyController.createProperty);
router.get('/', propertyController.getAllProperties);
router.get('/:id', propertyController.getPropertyById);
router.put('/:id', propertyController.updateProperty);
router.put('/occupied/:id', propertyController.updateIsOccupied);
router.delete('/:id', propertyController.deleteProperty);
router.get('/owner/:ownerId', propertyController.getPropertiesByOwnerId);

module.exports = router;
