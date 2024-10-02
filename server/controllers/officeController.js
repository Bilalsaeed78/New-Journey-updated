const Office = require('../models/officeModel');

exports.createOffice = async (req, res) => {
    try {
        const { office_address, address, overview,  rental_price, wifiAvailable, acAvailable, cabinsAvailable, max_capacity, contact_number, owner, location } = req.body;
        const locationObject = JSON.parse(location);
        const coordinates = locationObject.coordinates;

        if (!office_address || !address || !rental_price || !cabinsAvailable || !max_capacity || !contact_number 
            || !location || !owner) {
            return res.status(400).json({ success: false, message: "All required fields must be provided"});
        }

        const images = req.uploadedImages.map(image => image.url);

        const office = new Office({
            office_address,
            address,
            overview,
            rental_price,
            wifiAvailable,
            acAvailable,
            cabinsAvailable,
            max_capacity,
            contact_number,
            location: { 
                type: "Point",
                coordinates: [coordinates[1], coordinates[0]]
            },
            owner,
            images 
        });

        await office.save();

        res.status(201).json({ success: true, message: "Office created successfully", office });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};


exports.getAllOffices = async (req, res) => {
    try {
        const offices = await Office.find();
        res.status(200).json({ success: true, count: offices.length, offices });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.getOfficeById = async (req, res) => {
    try {
        const office = await Office.findById(req.params.id);
        if (!office) {
            res.status(404).json({ success: false, message: "Office not found" });
            return;
        }
        res.status(200).json({ success: true, office });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.updateOffice = async (req, res) => {
    try {
        const { office_address, address, overview,rental_price, wifiAvailable, acAvailable, cabinsAvailable, max_capacity, contact_number } = req.body;

        let office = await Office.findById(req.params.id);
        if (!office) {
            res.status(404).json({ success: false, message: "Office not found" });
            return;
        }

        office.address = address || office.address;
        office.office_address = office_address || office.office_address;
        office.overview = overview || office.overview;
        office.rental_price = rental_price || office.rental_price;
        office.wifiAvailable = wifiAvailable || office.wifiAvailable;
        office.acAvailable = acAvailable || office.acAvailable;
        office.cabinsAvailable = cabinsAvailable || office.cabinsAvailable;
        office.max_capacity = max_capacity || office.max_capacity;
        office.contact_number = contact_number || office.contact_number;

        await office.save();

        res.status(200).json({ success: true, message: "Office updated successfully", office });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

exports.deleteOffice = async (req, res) => {
    try {
        const office = await Office.findById(req.params.id);
        if (!office) {
            res.status(404).json({ success: false, message: "Office not found" });
            return;
        }

        await office.deleteOne();

        res.status(200).json({ success: true, message: "Office deleted successfully" });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};
