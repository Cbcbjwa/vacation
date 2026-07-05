/*
*Ella Muro
*July 5 2026
*Query Handler for Refresh Tokens MySQL Table
*/

//Importing the database connection
const db = require('../db');

//Method to add a new refresh token to the table
async function insertRefreshToken(userId, token, expiresAt) {
    await db.query(
        `INSERT INTO refreshTokens (userId, token, expiresAt)
         VALUES (?, ?, ?)`,
        [userId, token, expiresAt]
    );
}

//Method to retrieve a refresh token from the table
async function getRefreshToken(token) {
    const [rows] = await db.query(
        `SELECT *
         FROM refreshTokens
         WHERE token = ?`,
        [token]
    );

    return rows[0];
}

//Method to delete a refresh token from the table for logging out
async function deleteRefreshToken(token) {
    await db.query(
        `DELETE FROM refreshTokens
         WHERE token = ?`,
        [token]
    );
}

module.exports = { insertRefreshToken, getRefreshToken, deleteRefreshToken };