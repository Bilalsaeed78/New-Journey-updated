const Review = require('../models/reviewModel');

exports.createReview = async (req, res) => {
    try {
        const { user_id, property_id, type, rating, comments } = req.body;
        const review = new Review({
            user_id,
            property_id,
            type,
            rating,
            comments,
        });
        await review.save();
        res.status(201).json({ success: true, message: "Review created successfully", review });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getAllReviews = async (req, res) => {
    try {
        const reviews = await Review.find();
        res.status(200).json({ success: true, count: reviews.length, reviews });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getReviewById = async (req, res) => {
    try {
        const review = await Review.findById(req.params.id);
        if (!review) {
            res.status(404).json({ success: false, message: "Review not found" });
            return;
        }
        res.status(200).json({ success: true, review });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getReviewsOfSpecificProperty = async (req, res) => {
    try {
        const { property_id } = req.params;
        const reviews = await Review.find({ property_id }).populate('user_id');
        res.status(200).json({ success: true, count: reviews.length, reviews });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.deleteReview = async (req, res) => {
    try {
        const review = await Review.findById(req.params.id);
        if (!review) {
            res.status(404).json({ success: false, message: "Review not found" });
            return;
        }
        await review.deleteOne();
        res.status(200).json({ success: true, message: "Review deleted successfully" });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};
