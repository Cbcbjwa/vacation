/*
*Ella Muro
*24 April 2026
*Database Connection Setup
*/

const mysql = require('mysql2/promise');

const pool = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
});

module.exports = pool;
