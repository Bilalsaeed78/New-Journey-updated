const express = require('express');
const router = express.Router();
const roomController = require('../controllers/roomController');
const uploadToCloudinary = require('../middlewares/uploadFiles');

router.post('/', uploadToCloudinary.uploadMultipleToCloudinary, roomController.createRoom);
router.get('/', roomController.getAllRooms);
router.get('/:id', roomController.getRoomById);
router.put('/:id', roomController.updateRoom);
router.delete('/:id', roomController.deleteRoom);

module.exports = router;
