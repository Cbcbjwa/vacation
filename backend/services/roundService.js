/*
*Ella Muro
*June 6 2026
*Query Handler for Rounds MySQL Table
*/

//Importing the database connection
const pool = require('../db');

//Method for loading users from the database
async function loadRounds() {
    const [rows] = await pool.query(
        "SELECT * FROM round ORDER BY roundNumber"
    )
    return rows;
}

//Method for updating the round
async function updateRound(roundNumber, isActive) {
    await pool.query(
        "UPDATE round SET isActive=? WHERE roundNumber=?;",
        [isActive, roundNumber]
    )
}

//Method for updating the round completion 
async function updateRoundActivity(roundNumber, isComplete) {
    await pool.query(
        "UPDATE round SET isComplete=? WHERE roundNumber=?;",
        [isComplete, roundNumber]
    )

}

module.exports = { loadRounds, updateRound, updateRoundActivity };