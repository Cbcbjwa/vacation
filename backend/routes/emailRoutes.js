console.log("EMAIL ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const {deliverEmail } = require("../controllers/emailController");


router.post("/deliverEmail", deliverEmail);

module.exports = router;