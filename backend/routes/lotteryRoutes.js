console.log("LOTTERY ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { beginTurn, beginRound, stopTimer, transitionTurn } = require("../controllers/lotteryController");


router.post("/beginRound", beginRound);
router.post("/transitionTurn", transitionTurn);
router.post("/stopTimer", stopTimer);
router.post("/beginTurn", beginTurn);

module.exports = router;