/*
*Ella Muro
*26 May 2026
*Query Handler for Selections MySQL Table
*/

//Importing the database connection
const pool = require('../db');

//Method for adding a new site to the database
async function createSelection(userId, weekId, roundNumber) {
    
    const [result] = await pool.query(
        "INSERT into selections (userId, weekId, roundNumber) VALUES (?, ?, ?)",
        [userId, weekId, roundNumber]
    );

    await pool.query(
        "UPDATE weeks SET availableSlots = availableSlots - 1 WHERE weekId = ?",
        [weekId]
);

    console.log("INSERT RESULT:", result);

    return result;
}

//Method for loading selections from the database
async function loadSelections() {
    const [rows] = await pool.query(
        "SELECT selectionId, userId, weekId, roundNumber FROM selections ORDER BY selectionId"
    );
    return rows;
}

//Method for updating a selection in the database
async function updateSelection(selectionId, weekId) {

    const [rows] = await pool.query(
        "SELECT weekId FROM selections WHERE selectionId=?",
        [selectionId]
    );

    const oldWeekId = rows[0].weekId;

    if(oldWeekId === weekId) {
        return;
    }

    await pool.query(
        "UPDATE weeks SET availableSlots = availableSlots + 1 WHERE weekId=?",
        [oldWeekId]
    )

    const [result] = await pool.query(
        "UPDATE weeks SET availableSlots = availableSlots - 1 WHERE weekId=? AND availableSlots > 0",
        [weekId]
    )

    if(result.affectedRows === 0) {
        throw new Error("No slots available");
    }

    await pool.query(
        "UPDATE selections SET weekId=? WHERE selectionId=?",
        [weekId, selectionId]
    )
    
   /*const [result] = await pool.query(
        "UPDATE selections SET weekId=? WHERE selectionId=?",
        [weekId, selectionId]
    );
    return result;*/
}

//Method for deleting selections from the database
async function deleteSelection(selectionId) {
    await pool.query(
        "DELETE FROM selections WHERE selectionId=?;",
        [selectionId]
    );
}

//Method to load a selection by the user id and round number
async function getSelectionByUserAndRound(userId, roundNumber) {
    const [rows] = await pool.query(
        "SELECT * FROM selections WHERE userId = ? AND roundNumber = ?",
        [userId, roundNumber]
    );

    return rows[0];
}

//Method to load all selections for an individual user
async function getSelectionsByUser(userId) {
    const [rows] = await pool.query(
        "SELECT * FROM selections WHERE userId = ?",
        [userId]
    );

    return rows;
}

module.exports = { createSelection, loadSelections, updateSelection, deleteSelection, getSelectionByUserAndRound, getSelectionsByUser};