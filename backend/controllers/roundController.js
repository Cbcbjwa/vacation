//Imports
const { loadRounds, updateRound } = require("../services/roundService");

//Method for loading rounds
async function getRounds(req, res) {
  try {
    const rounds = await loadRounds();
    res.json(rounds);
  } catch (error) {
    console.log("GET ROUNDS ERROR:", error);
    res.status(500).json({ error: "Failed to load rounds" });
  }
}

//Method for updating a round
async function update(req, res) {
    const { roundNumber, isActive } = req.body;

    try {
        await updateRound(roundNumber, isActive)
        res.json({ success: true });
    } catch (error) {
        console.log("UPDATE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for updating a round activity
async function updateActivity(req, res) {
    const { roundNumber, isComplete } = req.body;

    try {
        await updateRound(roundNumber, isComplete)
        res.json({ success: true });
    } catch (error) {
        console.log("UPDATE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { getRounds, update, updateActivity };


