const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const { Resend } = require("resend");

const resend = new Resend(process.env.RESEND_API_KEY);

//Debugging print
console.log(process.env.RESEND_API_KEY);

async function sendTestEmail() {
  await resend.emails.send({
    from: 'onboarding@resend.dev',
    to: 'voorheesvalorum@gmail.com',
    subject: 'Test Email',
    text: 'Hello from my vacation scheduling app!'
  });
}

async function sendEmail( to, subject, text ) {
  console.log("RAW TO:", to);
  console.log("TYPE:", typeof to);
  console.log("JSON:", JSON.stringify(to));
  
  try {
    const result = await resend.emails.send({
      from: "notifications@esavacationlottery.com",
      to,
      cc: "fidesfalsus9@gmail.com",
      subject,
      text,
    });

    console.log("RESEND RESULT: ", result);

    return result;
  
  } catch (error) {
    console.error("Email error:", error);
    throw error;
  }
}

module.exports = { sendEmail };