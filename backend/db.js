/*
*Ella Muro
*24 April 2026
*Database Connection Setup
*/

const mysql = require('mysql2/promise');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'CharlesLeeRay!',
    database: 'vacationdb',
});

module.exports = pool;
