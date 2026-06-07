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

module.exports = { loadRounds };