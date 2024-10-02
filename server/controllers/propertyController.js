const Property = require('../models/propertyModel');
const Room = require('../models/roomModel');
const Apartment = require('../models/apartmentModel');
const Office = require('../models/officeModel');
const mongoose = require('mongoose');

exports.createProperty = async (req, res) => {
    try {
        const { ownerId, propertyId, type } = req.body;

        if (!ownerId || !propertyId || !type) {
            return res.status(400).json({ success: false, message: 'All required fields must be provided' });
        }

        const existingProperty = await Property.findOne({ propertyId });
        if (existingProperty) {
            return res.status(400).json({ success: false, message: 'Property ID already exists' });
        }

        const property = new Property({
            ownerId,
            propertyId,
            type
        });

        await property.save();

        res.status(201).json({ success: true, message: 'Property created successfully', property });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.deleteProperty = async (req, res) => {
    try {
        const property = await Property.findById(req.params.id);
        if (!property) {
            return res.status(404).json({ success: false, message: 'Property not found' });
        }

        await property.deleteOne();

        res.status(200).json({ success: true, message: 'Property deleted successfully' });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.getAllProperties = async (req, res) => {
    try {
        const properties = await Property.find();
        res.status(200).json({ success: true, count: properties.length, properties });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.getPropertyById = async (req, res) => {
    try {
        const property = await Property.findById(req.params.id);
        if (!property) {
            return res.status(404).json({ success: false, message: 'Property not found' });
        }
        res.status(200).json({ success: true, property });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.updateProperty = async (req, res) => {
    try {
        const { ownerId, propertyId, type } = req.body;

        let property = await Property.findById(req.params.id);
        if (!property) {
            return res.status(404).json({ success: false, message: 'Property not found' });
        }

        property.ownerId = ownerId || property.ownerId;
        property.propertyId = propertyId || property.propertyId;
        property.type = type || property.type;

        await property.save();
        res.status(200).json({ success: true, message: 'Property updated successfully', property });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.getPropertiesByOwnerId = async (req, res) => {
    try {
        const properties = await Property.find({ ownerId: req.params.ownerId });
        res.status(200).json({ success: true, count: properties.length, properties });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.updateIsOccupied = async (req, res) => {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
        const { isOccupied, propertyType } = req.body;

        if (isOccupied === undefined || !propertyType) {
            await session.abortTransaction();
            session.endSession();
            return res.status(400).json({ success: false, message: 'isOccupied and propertyType must be provided and valid' });
        }

        const property = await Property.findById(req.params.id).session(session);
        if (!property) {
            await session.abortTransaction();
            session.endSession();
            return res.status(404).json({ success: false, message: 'Property not found' });
        }

        let propertyDetails;
        switch (propertyType.toLowerCase()) {
            case 'room':
                propertyDetails = await Room.findById(property.propertyId).session(session);
                break;
            case 'office':
                propertyDetails = await Office.findById(property.propertyId).session(session);
                break;
            case 'apartment':
                propertyDetails = await Apartment.findById(property.propertyId).session(session);
                break;
            default:
                await session.abortTransaction();
                session.endSession();
                return res.status(400).json({ success: false, message: 'Invalid property type' });
        }

        if (!propertyDetails) {
            await session.abortTransaction();
            session.endSession();
            return res.status(404).json({ success: false, message: 'Property details not found' });
        }

        if (isOccupied) {
            if (propertyDetails.max_capacity <= 0) {
                await session.abortTransaction();
                session.endSession();
                return res.status(400).json({ success: false, message: 'Property is out of space' });
            }
            propertyDetails.max_capacity -= 1;
        } else {
            propertyDetails.max_capacity += 1;            
        }
        

        if (propertyDetails.max_capacity <= 0) {
            property.isOccupied = true;
        } else {
            property.isOccupied = false;
        }

        await propertyDetails.save({ session });
        await property.save({ session });

        await session.commitTransaction();
        session.endSession();

        res.status(200).json({ success: true, message: 'Property occupancy status updated successfully', property });
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        console.error(error.message);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};