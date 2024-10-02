const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    booking_id: {
        type: String,
        required: true,
        unique: true
    },
    property_id: {
        type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    type: {
        type: String,
        enum: ['room', 'apartment', 'office'],
        required: true
    },
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    date_of_creation: {
        type: Date,
        default: Date.now
    },
    status: {
        type: String,
        enum: ['pending', 'confirmed', 'cancelled'],
        default: 'pending'
    }
});

module.exports = mongoose.model('Booking', bookingSchema);
