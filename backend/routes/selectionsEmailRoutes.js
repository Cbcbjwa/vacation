console.log("SELECTIONS EMAIL ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { deliverSelections } = require("../controllers/selectionsEmailController");


router.post("/deliverSelections", deliverSelections);

module.exports = router;