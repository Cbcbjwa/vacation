//Imports
const { insertRefreshToken, getRefreshToken, deleteRefreshToken } = require("../services/refreshTokenService");

//Method for loading refresh tokens
async function retrieveRefreshToken(req, res) {

    const { token } = req.body;

    try {
        const refreshToken = await getRefreshToken(token);
        res.json(refreshToken);
    } catch (error) {
        console.log("RETRIEVE REFRESH TOKEN ERROR:", error);
        res.status(500).json({ error: "Failed to retrieve refresh token" });
    }
}

//Method for inserting a refresh token
async function addRefreshToken(req, res) {

    const { userId, token, expiresAt } = req.body;

    try {
        await insertRefreshToken(userId, token, expiresAt);
        res.json({ success: true });
    } catch (error) {
        console.log("ADD REFRESH TOKEN ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for deleting a refresh token
async function destroyRefreshToken(req, res) {

    const { token } = req.body;

    try {
        await deleteRefreshToken(token);
        res.json({ success: true });
    } catch (error) {
        console.log("DESTORY REFRESH TOKEN ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { retrieveRefreshToken, addRefreshToken, destroyRefreshToken };


