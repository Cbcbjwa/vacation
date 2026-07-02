console.log("LOTTERY ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { beginTurn, beginRound, stopTimer } = require("../controllers/lotteryController");


router.post("/beginTurn", beginTurn);
router.post("/beginRound", beginRound);
router.post("/stopTimer", stopTimer);

module.exports = router;