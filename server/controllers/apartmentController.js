const Apartment = require('../models/apartmentModel');

exports.createApartment = async (req, res) => {
    try {
        const { apartment_number, address, overview, rental_price, floor, rooms, max_capacity, liftAvailable, contact_number, owner, location } = req.body;
        const locationObject = JSON.parse(location);
        const coordinates = locationObject.coordinates;

        if (!apartment_number || !address || !rental_price || !floor || !rooms || !max_capacity || !contact_number || !location || !owner) {
            return res.status(400).json({ success: false, message: "All required fields must be provided"});
        }

        const images = req.uploadedImages.map(image => image.url);

        const apartment = new Apartment({
            apartment_number,
            address,
            overview,
            rental_price,
            floor,
            rooms,
            max_capacity,
            liftAvailable,
            
            contact_number,
            location: { 
                type: "Point",
                coordinates: [coordinates[1], coordinates[0]]
            },
            owner,
            images 
        });

        await apartment.save();

        res.status(201).json({ success: true, message: "Apartment created successfully", apartment });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.updateApartment = async (req, res) => {
    try {
        const { apartment_number, address, overview, rental_price, floor, rooms, max_capacity, liftAvailable, contact_number, images } = req.body;

        if (!apartment_number || !address || !rental_price || !floor || !rooms || !max_capacity || !contact_number ) {
            return res.status(400).json({ success: false, message: "All required fields must be provided"});
        }

        let apartment = await Apartment.findById(req.params.id);
        if (!apartment) {
            res.status(404).json({ success: false, message: "Apartment not found" });
            return;
        }


        apartment.apartment_number = apartment_number;
        apartment.overview = overview;
        apartment.rental_price = rental_price;
        apartment.floor = floor;
        apartment.rooms = rooms;
        apartment.address = address;
        apartment.max_capacity = max_capacity;
        apartment.liftAvailable = liftAvailable;
        apartment.contact_number = contact_number;

        await apartment.save();

        res.status(200).json({ success: true, message: "Apartment updated successfully", apartment });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getAllApartments = async (req, res) => {
    try {
        const apartments = await Apartment.find();
        res.status(200).json({ success: true, count: apartments.length, apartments });
    } catch (error) {
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getApartmentById = async (req, res) => {
    try {
        const apartment = await Apartment.findById(req.params.id);
        if (!apartment) {
            res.status(404).json({ success: false, message: "Apartment not found" });
            return;
        }
        res.status(200).json({ success: true, apartment });
    } catch (error) {
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.deleteApartment = async (req, res) => {
    try {
        const apartment = await Apartment.findById(req.params.id);
        if (!apartment) {
            res.status(404).json({ success: false, message: "Apartment not found" });
            return;
        }

        await apartment.deleteOne();

        res.status(200).json({ success: true, message: "Apartment deleted successfully" });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};
