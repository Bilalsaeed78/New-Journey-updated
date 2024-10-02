const Room = require('../models/roomModel');

exports.createRoom = async (req, res) => {
    try {
        const { room_number, address, overview, rental_price, max_capacity, wifiAvailable, location, contact_number, owner } = req.body;
        const locationObject = JSON.parse(location);
        const coordinates = locationObject.coordinates;

        if (!room_number || !address || !rental_price || !max_capacity || !contact_number || !location || !owner || !wifiAvailable) {
            res.status(400);
            throw new Error("All required fields must be provided");
        }

        const images = req.uploadedImages.map(image => image.url);

        const room = new Room({
            room_number,
            address,
            overview,
            rental_price,
            max_capacity,
            wifiAvailable,
            contact_number,
            location: {
                type: "Point",
                coordinates: [coordinates[1], coordinates[0]]
            },
            owner,
            images
        });

        await room.save();

        res.status(201).json({ success: true, message: "Room created successfully", room });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};


exports.updateRoom = async (req, res) => {
    try {
        const { room_number, address, overview, rental_price, max_capacity, wifiAvailable, contact_number } = req.body;

        let room = await Room.findById(req.params.id);
        if (!room) {
            res.status(404).json({ success: false, message: "Room not found" });
            return;
        }

        room.address = address || room.address;
        room.room_number = room_number || room.room_number;
        room.overview = overview || room.overview;
        room.rental_price = rental_price || room.rental_price;
        room.max_capacity = max_capacity || room.max_capacity;
        room.wifiAvailable = wifiAvailable || room.wifiAvailable;
        room.contact_number = contact_number || room.contact_number;

        await room.save();

        res.status(200).json({ success: true, message: "Room updated successfully", room });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getAllRooms = async (req, res) => {
    try {
        const rooms = await Room.find();
        res.status(200).json({ success: true, count: rooms.length, rooms });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getRoomById = async (req, res) => {
    try {
        const room = await Room.findById(req.params.id);
        if (!room) {
            res.status(404).json({ success: false, message: "Room not found" });
            return;
        }
        res.status(200).json({ success: true, room });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.deleteRoom = async (req, res) => {
    try {
        const room = await Room.findById(req.params.id);
        if (!room) {
            res.status(404).json({ success: false, message: "Room not found" });
            return;
        }
        await room.deleteOne();

        res.status(200).json({ success: true, message: "Room deleted successfully" });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};
