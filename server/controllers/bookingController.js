const Booking = require('../models/bookingModel');

exports.createBooking = async (req, res) => {
    try {
        const { booking_id, property_id, type, user_id } = req.body;

        const booking = new Booking({
            booking_id,
            property_id,
            type,
            user_id
        });

        await booking.save();

        res.status(201).json({ success: true, message: "Booking created successfully", booking });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getAllBookings = async (req, res) => {
    try {
        const bookings = await Booking.find();
        res.status(200).json({ success: true, count: bookings.length, bookings });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getBookingById = async (req, res) => {
    try {
        const booking = await Booking.findById(req.params.id);
        if (!booking) {
            res.status(404).json({ success: false, message: "Booking not found" });
            return;
        }
        res.status(200).json({ success: true, booking });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.updateBooking = async (req, res) => {
    try {
        const { status } = req.body;

        let booking = await Booking.findById(req.params.id);
        if (!booking) {
            res.status(404).json({ success: false, message: "Booking not found" });
            return;
        }

        booking.status = status || booking.status;

        await booking.save();

        res.status(200).json({ success: true, message: "Booking updated successfully", booking });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.deleteBooking = async (req, res) => {
    try {
        const booking = await Booking.findById(req.params.id);
        if (!booking) {
            res.status(404).json({ success: false, message: "Booking not found" });
            return;
        }

        await booking.deleteOne();

        res.status(200).json({ success: true, message: "Booking deleted successfully" });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};
