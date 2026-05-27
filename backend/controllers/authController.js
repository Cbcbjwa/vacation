const bcrypt = require("bcrypt");
const { getUsersByEmail } = require("../services/userService");

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

        res.json({
            success: true,
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
                displayName: user.displayName
            },
        });
    } catch (err) {
        console.log("LOGIN ERROR:", err);
        res.status(500).json({ success: false });
    }
}

module.exports = { login };