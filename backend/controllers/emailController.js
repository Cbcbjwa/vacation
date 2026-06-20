//Imports
const { sendEmail } = require("../services/emailService");

//Method for sending emails
async function deliverEmail(req, res) {

    const { to, subject, text } = req.body;

    try {
        await sendEmail(to, subject, text)
        res.json({ success: true });
    } catch (error) {
        console.log("DELIVER EMAIL ERROR:", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { deliverEmail };