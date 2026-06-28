/*
* Ella Muro
* 8 June 2026
* Round Eligibility Logic
*/

class RoundEligibilityService {

    constructor() {

        this.totalRounds = 9;
        this.totalPrepicks = 2;

    }

    // Returns a true/false array for rounds
    // Index 0 = Round 1
    computeRoundEligibility(weeksAllowed) {

        return Array.from(

            { length: this.totalRounds },

            (_, i) => (i + 1) <= weeksAllowed

        );

    }

    // Returns a true/false array for prepicks
    // Index 0 = Prepick 1
    computePrepickEligibility(prepicksAllowed) {

        return Array.from(

            { length: this.totalPrepicks },

            (_, i) => (i + 1) <= prepicksAllowed

        );

    }

}

module.exports = RoundEligibilityService;