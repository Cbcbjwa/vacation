console.log("SITE ROUTES FILE LOADED");

const express = require("express");
const router = express.Router();
const { getSites, update, addSite, remove } = require("../controllers/siteController");


router.get("/", getSites);
router.put("/update", update);
router.post("/addSite", addSite);
router.delete("/:siteId", remove);

module.exports = router;