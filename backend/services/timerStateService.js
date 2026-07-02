/*
*Ella Muro
*25 June 2026
*Query Handler for Timer State MySQL Table
*/

//Importing the database connection
const pool = require('../db');

//Method for loading the timer state from the databsae
async function loadTimerState() {
    const [rows] = await pool.query(
        "SELECT * FROM timerstate"
    );
    return rows;
}

//Method for updating the timer state
async function updateTimerState(timerStateId, timerIsActive, turnEndTime) {

    console.log("timerStateId =", timerStateId);
    console.log("timerIsActive: ", timerIsActive);
    console.log("turnEndTime: ", turnEndTime)

    await pool.query(
        "UPDATE timerstate SET "
            + "timerIsActive=?, "
            + "turnEndTime=? "
            + "WHERE timerStateId=?;",
        [timerIsActive, turnEndTime, timerStateId]
    )
}

module.exports = { loadTimerState, updateTimerState };