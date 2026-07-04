const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const twilio = require("twilio");

class SmsService {

    constructor() {

        this.client = twilio(
            process.env.TWILIO_ACCOUNT_SID,
            process.env.TWILIO_AUTH_TOKEN
        );

        this.fromNumber = process.env.TWILIO_PHONE_NUMBER;
    }

    async formatPhoneNumber(phone) {

        if(!phone) return null;

        //Removing everything from the phone number string except the digits
        let cleaned = phone.replace(/\D/g, "");

        //If it's a US number without country code
        if (cleaned.length === 10) {
            cleaned = "1" + cleaned;
        }

        return "+" + cleaned;
    }

    async sendSMS(to, body) {

        if (!to) {
            throw new Error("Recipient phone number is required.");
        }

        const formattedTo = formatPhoneNumber(to);

        return await this.client.messages.create({

            from: this.fromNumber,
            to: formattedTo,
            body

        });
    }
}

module.exports = SmsService;