const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/reviewController');

router.post('/', reviewController.createReview);
router.get('/', reviewController.getAllReviews);
router.get('/:id', reviewController.getReviewById);
router.get('/property/:property_id', reviewController.getReviewsOfSpecificProperty);
router.delete('/:id', reviewController.deleteReview);

module.exports = router;
