/*
*Ella Muro
*22 May 2026
*Query Handler for Weeks MySQL Table
*/

//Importing the database connection
const pool = require('../db');

//Method for adding a new week to the database (Crud)
async function createWeek(weekNumber, weekDate, specialSpecification, totalSlots) {

    //Setting available slots equal to total slots - all slots begin available
    const availableSlots = totalSlots;

    await pool.query(
        "INSERT INTO weeks (weekNumber, weekDate, availableSlots, specialSpecification, totalSlots) VALUES (?, ?, ?, ?, ?)",
        [weekNumber, weekDate, availableSlots, specialSpecification, totalSlots]
    )
    console.log("Available Slots: ", availableSlots);
}

//Method for loading users from the database (cRud)
async function loadWeeks() {
    const [rows] = await pool.query(
        "SELECT w.*, (w.totalSlots - COUNT(s.selectionId)) AS availableSlots FROM weeks w LEFT JOIN selections s ON s.weekId = w.weekId GROUP BY w.weekId;"
    );
    console.log("DB ROWS:", rows);
    return rows;
}

//Method for updating a week in the database (crUd)
async function updateWeek(weekId, weekNumber, weekDate, specialSpecification, totalSlots) {

    await pool.query(
        "UPDATE weeks SET "
                + "weekNumber=?, "
                + "weekDate=?, "
                + "specialSpecification=?, "
                + "totalSlots=? "
                + "WHERE weekId=?;",
        [weekNumber, weekDate, specialSpecification, totalSlots, weekId]
    )
}

//Method for deleting weeks from the database (cruD)
async function deleteWeek(weekId) {
    await pool.query(
        "DELETE FROM weeks WHERE weekId=?;",
        [weekId]
    )
}

//Method to update number of available slots
async function updateAvailableSlots(weekId, availableSlots) {
    const [rows] = await pool.query(
        "UPDATE weeks SET availableSlots=? WHERE weekId=?",
        [availableSlots, weekId]
    );
}

module.exports = { createWeek, loadWeeks, updateWeek, deleteWeek, updateAvailableSlots };