require("dotenv").config();

const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");


const { getUsersByEmail, getUserById} = require("../services/userService");
const { insertRefreshToken, getRefreshToken, deleteRefreshToken} = require("../services/refreshTokenService");


//**Helper functions for generating tokens**\\
function generateAccessToken(user) {
    return jwt.sign(
        {
            userId: user.id,
            email: user.email
        },
        process.env.JWT_SECRET,
        {
            expiresIn: "15m"
        }
    );
}

function generateRefreshToken(user) {
    return jwt.sign(
        {
            userId: user.id
        },
        process.env.JWT_REFRESH_SECRET,
        {
            expiresIn: "365d"
        }
    );
}

async function login(req, res) {
    let { email, password } = req.body;

    password = password.trim();
    email = email.trim().toLowerCase();


    try {

        console.log("EMAIL RECEIVED:", email);

        const user = await getUsersByEmail(email);

        console.log("USER RESULT:", user);

        if (!user) {
            return res.status(401).json({ success: false });
        }

        console.log("PASSWORD INPUT:", JSON.stringify(password));
        console.log("HASH FROM DB:", user.passwordHash);

        const match = await bcrypt.compare(password, user.passwordHash);

        console.log("BCRYPT MATCH RESULT:", match);

        if (!match) {
            return res.status(401).json({
                success: false,
                message: "Invalid credentials",
            });
        }

        //Generating tokens
        const accessToken = generateAccessToken(user);
        const refreshToken = generateRefreshToken(user);

        //Adding newly-generated refresh token to the database
        await insertRefreshToken(user.id, refreshToken);

        res.json({
            success: true,

            accessToken,
            refreshToken,

            user: {
                id: user.id,
                userName: user.userName,
                email: user.email,
                docRole: user.docRole,
                weeksAllowed: user.weeksAllowed,
                prepicksAllowed: user.prepicksAllowed,
                priorityNumber: user.priorityNumber,
                prepicksPriorityNumber: user.prepicksPriorityNumber,
                label: user.label,
                displayName: user.displayName,
                phoneNumber: user.phoneNumber,
                label2: user.label2
            },
        });
    } catch (err) {
        console.log("LOGIN ERROR:", err);
        res.status(500).json({ success: false });
    }
}

//Refresh endpoint
async function refresh(req, res) {

    try {

        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(401).json({
                success: false,
                message: "Refresh token required"
            });
        }

        let payload;

        try {
            payload = jwt.verify(
                refreshToken,
                process.env.JWT_REFRESH_SECRET
            );
        } catch {
            return res.status(403).json({
                success: false,
                message: "Invalid refresh token"
            });
        }

        const storedToken = await getRefreshToken(refreshToken);

        if (!storedToken) {
            return res.status(403).json({
                success: false,
                message: "Invalid refresh token"
            });
        }

        //Loading the current user from the database
        const user = await getUserById(payload.userId);

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        const accessToken = generateAccessToken(user);

        res.json({
            success: true,

            accessToken,

            user: {
                id: user.id,
                userName: user.userName,
                email: user.email,
                docRole: user.docRole,
                weeksAllowed: user.weeksAllowed,
                prepicksAllowed: user.prepicksAllowed,
                priorityNumber: user.priorityNumber,
                prepicksPriorityNumber: user.prepicksPriorityNumber,
                label: user.label,
                displayName: user.displayName,
                phoneNumber: user.phoneNumber,
                label2: user.label2
            }
        });
    } catch (error) {
         return res.status(400).json({
            success: false,
            message: "REFRESH ERROR"
        });
    }
}

//Method to log the user out of the app
async function logout(req, res) {

    const { refreshToken } = req.body;

    if (!refreshToken) {
        return res.status(400).json({
            success: false,
            message: "Refresh token required"
        });
    }

    try {

        await deleteRefreshToken(refreshToken);

        res.json({
            success: true
        });

    } catch (err) {

        console.log("LOGOUT ERROR:", err);

        res.status(500).json({
            success: false
        });

    }
}

module.exports = { login, refresh, logout };