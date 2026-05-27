/*
*Ella Muro
*25 May 2026
*Query Handler for Sites MySQL Table
*/

//Importing the database connection
const pool = require('../db');

//Method for adding a new site to the database
async function createSite(siteName, maxDocsOffPerWeek) {
    
    await pool.query(
        "INSERT into sites (siteName, maxDocsOffPerWeek) VALUES (?, ?)",
        [siteName, maxDocsOffPerWeek]
    )
}

//Method for loading sites from the database
async function loadSites() {
    const [rows] = await pool.query(
        "SELECT siteId, siteName, maxDocsOffPerWeek FROM sites ORDER BY siteId"
    );
    return rows;
}

//Method for updating a site in the database
async function updateSite(siteId, siteName, maxDocsOffPerWeek) {
    await pool.query(
        "UPDATE sites SET "
                + "siteName=?, "
                + "maxDocsOffPerWeek=? "
                + "WHERE siteId=?;",
        [siteName, maxDocsOffPerWeek, siteId]
    )
}

//Method for deleting sites from the database
async function deleteSite(siteId) {
    await pool.query(
        "DELETE FROM sites WHERE siteId=?;",
        [siteId]
    )
}

module.exports = { createSite, loadSites, updateSite, deleteSite};