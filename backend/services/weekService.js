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
        "SELECT weekId, weekNumber, weekDate, availableSlots, specialSpecification, totalSlots FROM weeks ORDER BY weekNumber"
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

module.exports = { createWeek, loadWeeks, updateWeek, deleteWeek };