//Imports
const { emailSelections } = require("../services/selectionsEmailService");

//Method for sending emails
async function deliverSelections(req, res) {

    try {
        await emailSelections();
        res.json({ success: true });
    } catch (error) {
        console.log("DELIVER SELECTIONS ERROR:", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { deliverSelections };