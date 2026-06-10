//Imports
const {
  loadSysState,
  updateCurrentRoundNumber,
  updateCurrentTurnPriority
} = require("../services/sysStateService");

//Method for loading the system state
async function getSysState(req, res) {
  try {
    const sysState = await loadSysState();
    res.json(sysState);
  } catch (error) {
    console.log("GET SYS STATE ERROR:", error);
    res.status(500).json({ error: "Failed to load sys state" });
  }
}

//Method for updating the current round number
async function updateRoundNum(req, res) {

  console.log(req.body);

  const { sysStateId, currentRoundNumber } = req.body;

  try {
    await updateCurrentRoundNumber(sysStateId, currentRoundNumber);

    res.json({ success: true });
  } catch (error) {
    console.log("UPDATE ROUND NUM ERROR:", error);
    res.status(500).json({ success: false });
  }
}

//Method for updating the current turn priority
async function updateTurnPriority(req, res) {
    const { sysStateId, currentTurnPriority } = req.body;

    try {
        await updateCurrentTurnPriority(sysStateId, currentTurnPriority);
        res.json({ success: true });
    } catch (error) {
        console.log("UPDATE TURN PRIORITY ERROR:", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { getSysState, updateRoundNum, updateTurnPriority };