console.log("TIMER STATE ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { getTimerState, update } = require("../controllers/timerStateController");


router.get("/", getTimerState);
router.put("/update", update);


module.exports = router;