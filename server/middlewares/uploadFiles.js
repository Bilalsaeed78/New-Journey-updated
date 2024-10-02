const cloudinary = require("cloudinary").v2;
const multer = require("multer");
const fs = require("fs");
const path = require("path");

cloudinary.config({
    cloud_name: process.env.CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET
});

const UPLOADS_DIR = path.join(__dirname, 'uploads');

if (!fs.existsSync(UPLOADS_DIR)) {
    fs.mkdirSync(UPLOADS_DIR);
}

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, UPLOADS_DIR);
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    }
});

const upload = multer({
    storage: storage,
    limits: { fileSize: 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        const allowedExtensions = ['.jpeg', '.jpg', '.png', 'image/jpeg', 'image/png', 'image/jpg'];
        const fileExtension = path.extname(file.originalname).toLowerCase();
        
        if (allowedExtensions.includes(fileExtension)) {
            cb(null, true);
        } else {
            cb(new Error("Unsupported file format"), false);
        }
    }
});

const uploadSingleToCloudinary = (req, res, next) => {
    upload.single('profilePic')(req, res, async (err) => {
        console.log(err);
        if (err) {
            return res.status(400).json({ success: false, message: "Failed to upload image" });
        }

        try {
            if (!req.file) {
                return res.status(400).json({ success: false, message: "No file uploaded" });
            }

            const { path } = req.file;
            const result = await cloudinary.uploader.upload(path, { folder: "Profiles" });

            fs.unlinkSync(path);

            req.uploadedImage = { url: result.secure_url, id: result.public_id };
            next();
        } catch (error) {
            console.error(error.message);
            res.status(500).json({ success: false, message: "Server Error" });
        }
    });
};

const uploadMultipleToCloudinary = (req, res, next) => {
    upload.array('files')(req, res, async (err) => {
        if (err) {
            return res.status(400).json({ success: false, message: "Failed to upload images" });
        }

        try {
            const urls = [];

            for (const file of req.files) {
                const { path } = file;
                const result = await cloudinary.uploader.upload(path, { folder: "Images" });
                urls.push({ url: result.secure_url, id: result.public_id });
                fs.unlinkSync(path);
            }

            req.uploadedImages = urls;
            next();
        } catch (error) {
            console.error(error.message);
            res.status(500).json({ success: false, message: "Server Error" });
        }
    });
};

module.exports = { uploadSingleToCloudinary, uploadMultipleToCloudinary };
