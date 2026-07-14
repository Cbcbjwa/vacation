const { Resend } = require("resend");
const resend = new Resend(process.env.RESEND_API_KEY);
const db = require("../db");

async function emailSelections() {
    try {

        const [rows] = await db.query(`
            SELECT
                w.weekNumber,
                u.userName,
                s.roundNumber
            FROM selections s
            JOIN users u ON s.userId = u.userId
            JOIN weeks w ON s.weekId = w.weekId
            ORDER BY
                s.roundNumber,
                w.weekNumber,
                u.userName
        `);

        let csv = "Week Number,User Name,Round Number\n";

        rows.forEach(row => {
            csv += `${row.weekNumber},${row.userName},${row.roundNumber}\n`;
        });

        await resend.emails.send({
            from: "notifications@esavacationlottery.com",
            to: "voorheesvalorum@gmail.com",
            subject: "Vacation Selections",
            html: `
                <p>Hello,</p>
                <p>The current vacation selections are attached as a CSV file.</p>
            `,
            attachments: [
                {
                    filename: "Selections.csv",
                    content: Buffer.from(csv).toString("base64")
                }
            ]
        });

    } catch (err) {
        console.error("Error emailing selections:", err);
    }
}

module.exports = {
    emailSelections
};