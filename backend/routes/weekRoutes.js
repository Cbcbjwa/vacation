console.log("WEEK ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { getWeeks, update, addWeek, remove } = require("../controllers/weekController");


router.get("/", getWeeks);
router.put("/update", update);
router.post("/addWeek", addWeek);
router.delete("/:weekId", remove);

module.exports = router;