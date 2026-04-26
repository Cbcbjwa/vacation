/*
*Ella Muro
*24 April 2026
*Query Handler for Users MySQL Table
*/

//Importing the database connection
const pool = require('./db');

//Loading users from the MySQL table by their email
async function getUsersByEmail(email) {
    const[rows] = await pool.query(
        'SELECT * FROM users WHERE email = ?',
        [email]
    );

    //Returning users
    return rows[0];
}

module.exports = {
    getUsersByEmail,
};

const bcrypt = require('bcrypt');

async function createUser(name, email, password, role) {
  const saltRounds = 10;

  const hashedPassword = await bcrypt.hash(password, saltRounds);

  await db.query(
    "INSERT INTO users (userName, email, docRole, passwordHash) VALUES (?, ?, ?, ?)",
    [name, email, role, hashedPassword]
  );
}