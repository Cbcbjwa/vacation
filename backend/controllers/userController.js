//Imports
const bcrypt = require("bcrypt");
const {
  createUser,
  loadUsers,
  updateUser,
  deleteUser,
  changePassword
} = require("../services/userService");

//Method for adding new users
async function register(req, res) {
  const { email, password, userName, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber } = req.body;

  if (!email || !password || !userName || !docRole || weeksAllowed == null || prepicksAllowed == null || !displayName || !phoneNumber) {
    return res.status(400).json({ success: false, message: "Missing fields" });
  }

  try {

    await createUser(userName, email, password, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber);

    res.json({ success: true });

  } catch (error) {

    console.log("REGISTER ERROR:", error);
    res.status(500).json({ success: false });
  }
}

//Method for loading users
async function getUsers(req, res) {
  try {
    const users = await loadUsers();
    res.json(users);
  } catch (error) {
    console.log("GET USERS ERROR:", error);
    res.status(500).json({ error: "Failed to load users" });
  }
}

console.log("USER ROUTES LOADED");
console.log("loadUsers import:", loadUsers);

//Method for updating users
async function update(req, res) {
  const { id, email, userName, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber } = req.body;

  try {
    await updateUser(id, userName, email, docRole, weeksAllowed, prepicksAllowed, priorityNumber, prepicksPriorityNumber, label, displayName, phoneNumber);

    res.json({ success: true });
  } catch (error) {
    console.log("UPDATE ERROR:", error);
    res.status(500).json({ success: false });
  }
}

//Method for deleting a user
async function remove(req, res) {

  const { id } = req.params;

  try {
    await deleteUser(id);

    res.json({ success: true })
  } catch (error) {
    console.log("DELETE ERROR:", error);
    res.status(500).json({ success: false });
  }
}

//Method for changing password
async function updatePassword(req, res) {

  const { userId, currentPassword, newPassword } = req.body;

  try {
    await changePassword(userId, currentPassword, newPassword);

    res.json({
      success: true,
      message: "Password updated successfully"
    });
  } catch (error) {
     res.status(400).json({ success: false, error: error.message });
  }
}
 
module.exports = { register, getUsers, update, remove, updatePassword };
