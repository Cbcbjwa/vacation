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
async function changePassword(userId, newPassword, confirmNewPassword) {

    if(newPassword !== confirmNewPassword) {
        throw new Error("Passwords do not match");
    }

    const newHash = await bcrypt.hash(newPassword, 10);

    //Updating password in the database
    await pool.query(
        "UPDATE users SET passwordHash=? WHERE id=?",
        [newHash, userId]
    );
}

//Method to load a user by their id
async function getUserById(userId) {
    const[rows] = await pool.query(
        "SELECT * FROM users WHERE id=?",
        [userId]
    );

    //Returning users
    return rows[0];
}

module.exports = {getUsersByEmail, createUser, loadUsers, updateUser, deleteUser, changePassword, getUserById };