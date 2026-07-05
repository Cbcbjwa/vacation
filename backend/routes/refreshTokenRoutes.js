const express = require("express");
const router = express.Router();
const { retrieveRefreshToken, addRefreshToken, destroyRefreshToken } = require("../controllers/refreshTokenController");


router.get("/:token", retrieveRefreshToken);
router.post("/", addRefreshToken);
router.delete("/:token", destroyRefreshToken);

module.exports = router;