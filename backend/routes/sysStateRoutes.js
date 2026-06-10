console.log("SYS STATE ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { getSysState, updateRoundNum, updateTurnPriority } = require("../controllers/sysStateController");


router.get("/", getSysState);
router.put("/updateRoundNum", updateRoundNum);
router.put("/updateTurnPriority", updateTurnPriority);


module.exports = router;