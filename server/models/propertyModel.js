const mongoose = require('mongoose');

const propertySchema = new mongoose.Schema({
    ownerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    propertyId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        unique: true
    },
    isOccupied: {
        type: Boolean,
        default: false
    },
    type: {
        type: String,
        enum: ['room', 'apartment', 'office'],
        required: true
    }
});

module.exports = mongoose.model('Property', propertySchema);
