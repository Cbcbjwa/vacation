const systemStateService = require("./sysStateService");
const userService = require("./userService");
const roundService = require("./roundService");
const timerStateService = require("./timerStateService");
const emailService = require("./emailService");
const RoundEligibilityService = require('./roundEligibilityService');
const SmsService = require("./smsService");

class LotteryService {

    //Fields of the class
    constructor() {
        this.users = [];
        this.processingTransition = false;
        this.threeMinuteNotificationSent = false;
        this.oneMinuteNotificationSent = false;
        this.timerRunning = false;
        this.loopRunning = false;

        this.roundEligibilityService = new RoundEligibilityService();
        this.smsService = new SmsService();

        //Active user
        this.userWithActiveTurn = null;

        //Current round name
        this.roundName = null;

        this.systemState = null;
        this.rounds = [];

        this.turnEndTime = null;
    }



    //Method to load stuff
    async load() {

        //Loading system state
        this.systemState = await systemStateService.loadSysState();

        //Loading users
        this.users = await userService.loadUsers();

        //Loading rounds
        this.rounds = await roundService.loadRounds();
    }

    //Method to determine the user with an active turn
    async determineActiveUser() {

        //Determining the name of the current round
        const currentRound = this.rounds.find(round => round.roundNumber === this.systemState.currentRoundNumber);
        this.roundName = currentRound ? currentRound.roundName : "";

        console.log("Round:", this.systemState.currentRoundNumber);
        console.log("Looking for priority:", this.systemState.currentTurnPriority);

        for (const user of this.users) {
            console.log(
                user.displayName,
                "priority:", user.priorityNumber,
                "prepick:", user.prepicksPriorityNumber,
                "match priority:",
                user.priorityNumber === this.systemState.currentTurnPriority,
                "match prepick:",
                user.prepicksPriorityNumber === this.systemState.currentTurnPriority
            );
        }

        //Determining which user has an active turn
         if (this.systemState.currentRoundNumber < 1) {

            this.userWithActiveTurn = this.users.find(user => user.prepicksPriorityNumber === this.systemState.currentTurnPriority);

        } else {

            this.userWithActiveTurn = this.users.find(user => user.priorityNumber === this.systemState.currentTurnPriority);
        }

        console.log("Active user:", this.userWithActiveTurn);
    }

    //**Email Sending Methods**\\

    //Method to send an email to inform the user that their turn has begun
    async emailNotificationOfTurnStart() {

        if(!this.userWithActiveTurn) {
            console.log("No active user.");
            return;
        }

        console.log(`Sending to: ${this.userWithActiveTurn.email}`);

        //Sending the email
        await emailService.sendEmail({to: this.userWithActiveTurn.email, subject: "Your Turn", text: `Your window is open to select a vacation week for ${this.roundName} of the 2027 ESA Vacation Lottery.\nYou have 24 hours to confirm your selection. Please use the ESA Vacation App to review available weeks and make your selection. After 24 hours, your window will be closed, and you will need to contact your administrator to secure a week for this round.`});

        //Sending the text
        await this.smsService.sendSMS(this.userWithActiveTurn.phoneNumber, `Your window is open to select a vacation week for ${this.roundName} of the 2027 ESA Vacation Lottery.\nYou have 24 hours to confirm your selection. Please use the ESA Vacation App to review available weeks and make your selection. After 24 hours, your window will be closed, and you will need to contact your administrator to secure a week for this round.`);
    }

    //Method to send an email to remind the user to make a selection
    async emailReminderToPick(timeRemaining) {

        if(!this.userWithActiveTurn) {
            console.log("No active user.");
            return;
        }

        console.log(`Sending to: ${this.userWithActiveTurn.email}`);

        //Sending the email
        await emailService.sendEmail({to: this.userWithActiveTurn.email, subject: "**REMINDER**", text: `Your time-limited window for selecting a week for ${this.roundName} of the 2027 ESA Vacation Lottery is open. You have ${timeRemaining} hours to confirm your week. If you are having difficulties, or would prefer not to use the ESA Vacation App, please reach out to an administrator between the hours of 6am to 10pm for assistance.`});
        
        //Sending the text
        await this.smsService.sendSMS(this.userWithActiveTurn.phoneNumber, `Your time-limited window for selecting a week for ${this.roundName} of the 2027 ESA Vacation Lottery is open. You have ${timeRemaining} hours to confirm your week. If you are having difficulties, or would prefer not to use the ESA Vacation App, please reach out to an administrator between the hours of 6am to 10pm for assistance.`);
    
    }

    //Method to send an email to inform the user that their window to select a week has closed
    async emailToInformOfWindowClosure() {

        if(!this.userWithActiveTurn) {
            console.log("No active user.");
            return;
        }

        console.log(`Sending to: ${this.userWithActiveTurn.email}`);

        //Sending the email
        await emailService.sendEmail({to: this.userWithActiveTurn.email, subject: "Your Window has Closed", text: `Your window to select a vacation week has closed. Please reach out to an administrator between the hours of 6am and 10pm to confirm a week for ${this.roundName}.`});
        
        //Sending the text
        await this.smsService.sendSMS(this.userWithActiveTurn.phoneNumber, `Your window to select a vacation week has closed. Please reach out to an administrator between the hours of 6am and 10pm to confirm a week for ${this.roundName}.`);
    
    }



    //**Public Entry Point**\\
    async startTurn() {
        await this.startWindow();
    }


    //**Timer Start**\\
    async startWindow() {

        await this.load();
        await this.determineActiveUser();

         if(!this.systemState) {
            throw new Error("System state not loaded");
        }

        console.log("START WINDOW");

        //Email flags
        this.threeMinuteNotificationSent = false;
        this.oneMinuteNotificationSent = false;

        //Turn end time
        const turnEndTime = new Date(Date.now() + 5 * 60 * 1000);

        this.turnEndTime = turnEndTime;

        //Updating timer state
        await timerStateService.updateTimerState(1, true, turnEndTime);

        this.timerRunning = true;

        //Running timer loop
        this.runLoop();

        //Sending an email and text to inform the user that their window to select a vacation week has opened
        await this.emailNotificationOfTurnStart();
    }

    //**Timer Tick**\\
    async handleTick() {
        try {
            console.log("HANDLE TICK");

            if(!this.timerRunning || !this.turnEndTime) {
                return;
            }

            const remainingTime = this.turnEndTime.getTime() - Date.now();

            console.log("Remaining: ", Math.floor(remainingTime/1000));

            const remainingHours = remainingTime / (1000 * 60 * 60);

            //3 minute email/text reminder
            if(!this.threeMinuteNotificationSent && remainingTime <= 180000) {
                this.threeMinuteNotificationSent = true;

                //Sending email reminder to pick a week
                await this.emailReminderToPick(remainingHours);

            }

            //1 minute email/text reminder
            if(!this.oneMinuteNotificationSent && remainingTime <= 60000) {
                this.oneMinuteNotificationSent = true;

                //Sending email reminder to pick a week
                await this.emailReminderToPick(remainingHours);
            
            }

            //End of timer
            if(remainingTime <= 0) {

                //Ending timer
                this.timerRunning = false;

                //Sending an email and text to inform the user that their window to select a week has closed
                await this.emailToInformOfWindowClosure();


                await this.transition();
            }
        } catch (error) {
            console.log("Handle tick failure: ", error);
        }
    }

    //**Transition**\\
    async transition() {

        if(this.processingTransition) {
            return;
        }

        this.processingTransition = true;

        try {
            console.log("TRANSITION");

            await this.turnProgressionHandler();

            await this.load();

            await this.startWindow();
        } finally {
            this.processingTransition=false;
        }
    }

    //Method for runnning the timer loop
    async runLoop() {

        if(this.loopRunning) {
            return;
        }

        this.loopRunning = true;

        while(this.timerRunning) {
            try {
                await this.handleTick();
            } catch (err) {
                console.error("TICK ERROR:", err);
            }

            await new Promise(res => setTimeout(res, 1000));
        }

        this.loopRunning = false;
    }

    //**Start Round**\\
    async startRound(roundNumber) {

        //Ending timer
        await this.endTimer();

        //Updating the system state's round number
        await systemStateService.updateCurrentRoundNumber(1, roundNumber);

        //Setting the round's state to active
        await roundService.updateRound(roundNumber, true);

        //Updating the current turn priority
        await systemStateService.updateCurrentTurnPriority(1, 1);

        //Checking if priority number 1 can pick or if the turn needs to be advanced
        await this.checkIfNumber1CanPickOnStart();

        await this.startTurn();
    }

    //Method to check if turn priority 1 can pick or if the turn should be advanced upon round start
    async checkIfNumber1CanPickOnStart() {

        await this.load();
        await this.determineActiveUser();
        
        //Variable to represent whether or not number 1 can pick
        let number1CanPick = false;

        if(this.systemState.currentRoundNumber < 1) {
            const eligibility = this.roundEligibilityService.computePrepickEligibility(this.userWithActiveTurn.prepicksAllowed);

            number1CanPick = eligibility[this.systemState.currentRoundNumber + 1];
        } else {
            const eligibility = this.roundEligibilityService.computeRoundEligibility(this.userWithActiveTurn.weeksAllowed);

            number1CanPick = eligibility[this.systemState.currentRoundNumber - 1];
        }

        if(!number1CanPick) {
            await this.turnProgressionHandler(true);
        }
    }

    //**Turn Progression**\\
    async turnProgressionHandler(startAtCurrent = false) {

        console.log("===TURN PROGRESSION===");

        await this.endTimer();

        //Loading data
        await this.load();
        await this.determineActiveUser();

        //Current round
        const currentRound = this.systemState.currentRoundNumber;

        //Filtering users
        let users;

        if(currentRound > 0) {
            users = this.users
                .filter(user => (user.priorityNumber ?? 0) > 0)
                .sort((a, b) => a.priorityNumber - b.priorityNumber);
        } else {
            users = this.users
                .filter(user => (user.prepicksPriorityNumber ?? 0) > 0)
                .sort((a, b) => a.prepicksPriorityNumber - b.prepicksPriorityNumber);
        }

        //Max turn priority
        const maxTurnPriority = users.length;

        //Next turn priority
        let nextPriority = startAtCurrent
            ? this.systemState.currentTurnPriority
            : this.systemState.currentTurnPriority + 1;

        console.log(`Users: ${users.length}`);
        console.log(`Current Round: ${currentRound}`);
        console.log(`Current Priority: ${this.systemState.currentTurnPriority}`);

        while(nextPriority <= maxTurnPriority) {

            console.log(`Checking priority ${nextPriority}`);

            const user = users[nextPriority - 1];

            let canPick = false;

            if(currentRound < 1) {

                //Determining prepick picking eligibility
                const prepickEligibility = this.roundEligibilityService.computePrepickEligibility(user.prepicksAllowed);

                const prepickIndex = currentRound + 1;

                canPick = prepickEligibility[prepickIndex];
            } else {

                //Determining normal round eligibility
                const roundEligibility = this.roundEligibilityService.computeRoundEligibility(user.weeksAllowed);

                canPick = roundEligibility[currentRound - 1];

            }

            if(canPick) {
                console.log(`Updating priority to ${nextPriority}`);

                await systemStateService.updateCurrentTurnPriority(1, nextPriority);

                await this.load();
                await this.determineActiveUser();

                return;
            }
            nextPriority++;
 
        }

        //Nobody else can pick -- end of round
        await roundService.updateRound(currentRound, false);

        await roundService.updateRoundActivity(currentRound, true);

        await systemStateService.updateCurrentTurnPriority(1, 1)

        //Ending timer
        await this.endTimer();
    }

    //Method to end the timer
    async endTimer() {

        console.log("ENDING TIMER");

        this.timerRunning = false;
        this.turnEndTime = null;

        this.threeMinuteNotificationSent = false;
        this.oneMinuteNotificationSent = false;

        //Persisting timer state in MySQL
        await timerStateService.updateTimerState(
            1,          // timerStateId
            false,      // timerIsActive
            null        // turnEndTime
        );

        console.log("Timer ended");
    }

    //Method to resume the timer
    async resumeTimerIfNeeded() {

        await this.load();
        await this.determineActiveUser();

        const timerState = await timerStateService.loadTimerState();

        if (!timerState.timerIsActive) {
            console.log("No active timer.");
            return;
        }

        this.turnEndTime = new Date(timerState.turnEndTime);
        
        //If the timer already expired while the server was down
        if(Date.now() >= this.turnEndTime.getTime()) {
            console.log("Timer expired while server was offline.");

            await this.transition();
            return;
        }

        this.timerRunning = true;

        console.log("Resuming timer...");

        this.timerRunning = true;

        //Running timer loop
        this.runLoop();
    }
}

module.exports = new LotteryService();