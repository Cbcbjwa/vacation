//Imports
const { loadRounds } = require("../services/roundService");

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

module.exports = { getRounds };


