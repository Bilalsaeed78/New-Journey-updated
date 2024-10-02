const express = require("express");
const cors = require('cors');
const bodyParser = require('body-parser');
const connectDb = require('./configs/dbConnection');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(bodyParser.urlencoded({extended : true})); 
app.use(express.json());
connectDb();
require('./utils/routes')(app);

const port = process.env.PORT || 8050;
app.listen(port, () => console.log(`Listening on port ${port}...`));