const express = require("express");
const router = express.Router();
const weekController = require("../controllers/weekController");

router.post("/generate/:year", weekController.generateYear);

module.exports = router;