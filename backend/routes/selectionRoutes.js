console.log("SELECTION ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { getSelections, update, addSelection, remove, getSelection, getUserSelections, deleteEverySelection } = require("../controllers/selectionController");


router.get("/", getSelections);
router.put("/update", update);
router.post("/addSelection", addSelection);
router.delete("/deleteEverySelection", deleteEverySelection);
router.delete("/:selectionId", remove);
router.get("/user/:userId/round/:roundNumber", getSelection);
router.get("/user/:userId", getUserSelections);

module.exports = router;