const mongoose = require('mongoose');

const apartmentSchema = new mongoose.Schema({
    apartment_number: {
        type: String,
        required: true
    },
    address: {
        type: String,
        required: true
    },
    overview: {
        type: String
    },
    rental_price: {
        type: Number,
        required: true
    },
    floor: {
        type: Number,
        required: true
    },
    rooms: {
        type: Number,
        required: true
    },
    max_capacity: {
        type: Number,
        required: true
    },
    liftAvailable: {
        type: Boolean,
        default: false
    },
    contact_number: {
        type: String,
        required: true
    },
    location: {
        type: {
            type: String,
            default: 'Point',
        },
        coordinates: {
            type: [Number],
            required: true
        }
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    images: {
        type: [String],
    }
});

apartmentSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('Apartment', apartmentSchema);