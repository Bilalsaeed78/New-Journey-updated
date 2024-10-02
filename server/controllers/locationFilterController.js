const Property = require('../models/propertyModel');
const Room = require('../models/roomModel');
const Apartment = require('../models/apartmentModel');
const Office = require('../models/officeModel');
const Geopoint = require('geopoint');

const filterPropertiesByDistance = async (req, res) => {
    try {
        const { location } = req.body;
        if (!location) {
            return res.status(400).json({ success: false, message: "Location must be provided"});
        }

        const coordinates = location.coordinates;
        
        const propertyList = [];

        const maxDistance = 10; 
        const properties = await Property.find();

        for (const property of properties) {
            let propertyDetails;

            switch (property.type) {
                case 'room':
                    propertyDetails = await Room.findById(property.propertyId);
                    break;
                case 'office':
                    propertyDetails = await Office.findById(property.propertyId);
                    break;
                case 'apartment':
                    propertyDetails = await Apartment.findById(property.propertyId);
                    break;
                default:
                    break;
            }

            if (propertyDetails) {
                const point1 = new Geopoint(propertyDetails.location.coordinates[1], propertyDetails.location.coordinates[0]);
                const point2 = new Geopoint(coordinates[0], coordinates[1]);
                const distance = point1.distanceTo(point2, true);
                
                if (distance <= maxDistance) {
                    propertyList.push({ property: property, distance: distance });
                }
            }
        }
        
        return res.status(200).json({ success: true, propertyList });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'Failed to filter properties by distance' });
    }
};

module.exports = {
    filterPropertiesByDistance
};