/*
*Ella Muro
*24 April 2026
*Query Handler for Users MySQL Table
*/

//Importing the database connection
const pool = require('../db');
const bcrypt = require('bcrypt');

//Loading users from the MySQL table by their email
async function getUsersByEmail(email) {
    const[rows] = await pool.query(
        "SELECT * FROM users WHERE email = ?",
        [email]
    );

    //Returning users
    return rows[0];
}


//Method to create a new user
async function createUser(userName, email, password, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber, label2) {
  
    const saltRounds = 10;

    const hashedPassword = await bcrypt.hash(password, saltRounds);

    await pool.query(
        "INSERT INTO users (userName, email, docRole, passwordHash, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber, label2) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [userName, email, docRole, hashedPassword, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber, label2]
    );
}

//Method for loading users from the database
async function loadUsers() {
    const [rows] = await pool.query(
        "SELECT id, userName, email, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber, label2 FROM users"
    )
    return rows;
}

//Method for updating a user record in the database
async function updateUser(id, userName, email, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber, label2) {
    
    console.log("ID:", id);

    await pool.query(
        "UPDATE users SET "
                + "userName=?, "
                + "email=?, "
                + "docRole=?, "
                + "weeksAllowed=?, "
                + "prepicksAllowed=?, "
                + "priorityNumber=?, "
                + "prepicksPriorityNumber=?, "
                + "label=?, "
                + "displayName=?, "
                + "phoneNumber=?, "
                + "label2=? "
                + "WHERE id=?;",
        [userName, email, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber, label2, id]       
    )
}

//Method for deleting a user
async function deleteUser(id) {
    console.log("DELETE ID:", id);

    await pool.query(
        "DELETE FROM users WHERE id=?;",
        [id]
    )
}

//Method for changing password
async function changePassword(userId, currentPassword, newPassword) {

    //Getting current password from the database
    const [rows] = await pool.query(
        "SELECT passwordHash FROM users WHERE id=?",
        [userId]
    );

    if(rows.length === 0) {
        throw new Error("User not found");
    }

    const matches = await bcrypt.compare(currentPassword, rows[0].passwordHash);

    if(!matches) {
        throw new Error("Current password is incorrect");
    }

    const newHash = await bcrypt.hash(newPassword, 10);

    //Updating password in the database
    await pool.query(
        "UPDATE users SET passwordHash=? WHERE id=?",
        [newHash, userId]
    );
}

module.exports = {getUsersByEmail, createUser, loadUsers, updateUser, deleteUser, changePassword};