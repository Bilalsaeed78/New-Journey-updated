const asyncHandler = require('express-async-handler');
const jwt = require('jsonwebtoken');

const validateToken = (entityType) => asyncHandler(async (req, res, next) => {
    let token;
    let authHeader = req.headers.authorization || req.headers.Authorization;

    if (authHeader && authHeader.startsWith("Bearer")) {
        token = authHeader.split(" ")[1];

        try {
            const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
            req[entityType] = decoded[entityType];
            
            next();
        } catch (err) {
            res.status(401);
            return next(new Error(`Invalid ${entityType} token`));
        }
    } else {
        res.status(401);
        return next(new Error(`No ${entityType} token provided`));
    }
});

module.exports = validateToken;