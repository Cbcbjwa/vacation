function formatPhoneNumber(phone) {

    if (!phone) return null;

    let cleaned = phone.replace(/\D/g, "");

    if (cleaned.length === 10) {
        cleaned = "1" + cleaned;
    }

    return "+" + cleaned;
}

module.exports = { formatPhoneNumber };