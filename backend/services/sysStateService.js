/*
*Ella Muro
*8 June 2026
*Query Handler for System State MySQL Table
*/

//Importing the database connection
const pool = require('../db');

//Method for loading the system state from the databsae
async function loadSysState() {
    const [rows] = await pool.query(
        "SELECT * FROM systemState"
    );
    return rows;
}

//Method for updating the current round number in the database
async function updateCurrentRoundNumber(sysStateId, currentRoundNumber) {

    console.log("sysStateId =", sysStateId);
    console.log("currentRoundNumber =", currentRoundNumber);

    await pool.query(
        "UPDATE systemState SET currentRoundNumber=? WHERE sysStateId=?;",
        [currentRoundNumber, sysStateId]
    )
}

//Method for updating the current turn priority in the database
async function updateCurrentTurnPriority(sysStateId, currentTurnPriority) {
    await pool.query(
        "UPDATE systemState SET currentTurnPriority=? WHERE sysStateId=?;",
        [currentTurnPriority, sysStateId]
    )
}

module.exports = { loadSysState, updateCurrentRoundNumber, updateCurrentTurnPriority };