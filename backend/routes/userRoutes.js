const express = require("express");
const router = express.Router();
const { getUsers, register, update, remove } = require("../controllers/userController");


router.get("/", getUsers);
router.post("/register", register);
router.put("/update", update);
router.delete("/:id", remove);

module.exports = router;