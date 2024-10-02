const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: [true, "Please add email address"],
        unique: [true, "Email address already taken"],
    },
    password: {
        type: String,
        required: [true, "Please add password"],
        minlength: 8
    },
    role: {
        type: String,
        enum: ['guest', 'owner'],
        required: true
    },
    fullname: {
        type: String,
        required: true
    },
    contact_no: {
        type: String,
        required: true
    },
    cnic: {
        type: String,
        required: true,
        unique: true
    },
    profilePic: {
        type: String
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
});

module.exports = mongoose.model('User', userSchema);
