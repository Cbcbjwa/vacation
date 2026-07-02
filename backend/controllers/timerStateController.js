//Imports
const {
  loadTimerState,
  updateTimerState
} = require("../services/timerStateService");

//Method for loading the timer state
async function getTimerState(req, res) {
  try {
    const timerState = await loadTimerState();
    res.json(timerState);
  } catch (error) {
    console.log("GET TIMER STATE ERROR:", error);
    res.status(500).json({ error: "Failed to load timer state" });
  }
}

//Method for updating the timer state
async function update(req, res) {

  console.log(req.body);

  const { timerId, timerIsActive, turnEndTime } = req.body;

  try {
    await updateTimerState(timerId, timerIsActive, turnEndTime);

    res.json({ success: true });
  } catch (error) {
    console.log("UPDATE TIMER STATE ERROR:", error);
    res.status(500).json({ success: false });
  }
}

module.exports = { getTimerState, update };