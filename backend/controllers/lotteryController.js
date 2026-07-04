//Imports
const lotteryService = require('../services/lotteryService');

//Method for starting a user's turn
async function beginTurn(req, res) {

    try {
        await lotteryService.startTurn();
        res.json({ success: true });
    } catch (error) {
        console.log("BEGIN TURN ERROR:", error);
        res.status(500).json({ success: false });
    }
}

//Method for starting a round
async function beginRound(req, res) {

    console.log("START ROUND CONTROLLER");

    const { roundNumber } = req.body;

    try {
        await lotteryService.startRound(roundNumber);
        res.json({ success: true });
    } catch (error) {
        console.log("BEGIN ROUND ERROR:", error);
        res.status(500).json({ success: false });
    }
}

//Method for ending the timer
async function stopTimer(req, res) {
    try {
        await lotteryService.endTimer();
        res.json({ success: true });
    } catch (error) {
        console.log("STOP TIMER ERROR:", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { beginTurn, beginRound, stopTimer };