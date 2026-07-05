const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const { formatPhoneNumber } = require("../utilities/phoneUtils");

const twilio = require("twilio");

class SmsService {

    constructor() {

        this.client = twilio(
            process.env.TWILIO_ACCOUNT_SID,
            process.env.TWILIO_AUTH_TOKEN
        );

        this.fromNumber = process.env.TWILIO_PHONE_NUMBER;
    }

    async sendSMS(to, body) {

        console.log("📱 SMS ATTEMPT");
        console.log("TO:", to);
        console.log("FROM:", this.fromNumber);
        console.log("BODY:", body);

        if (!to) {
            throw new Error("Recipient phone number is required.");
        }

        const formattedTo = formatPhoneNumber(to);

        console.log("FORMATTED TO:", formattedTo);

        return await this.client.messages.create({

            from: this.fromNumber,
            to: formattedTo,
            body

        });

        console.log("📱 TWILIO RESULT:", result.sid);

        return result;
    }
}

module.exports = SmsService;