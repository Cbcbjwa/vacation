console.log("ROUND ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { getRounds, update, updateActivity } = require("../controllers/roundController");


router.get("/", getRounds);
router.put("/update", update);
router.put("/updateActivity", updateActivity);

module.exports = router;