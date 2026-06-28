/*
*Ella Muro
*9 June 2026
*Round Control Logic
*/

//Imports section
import 'systemState.dart';
import 'systemStateService.dart';
import 'userRepository.dart';
import 'user.dart';
import 'userService.dart';
import 'roundService.dart';
import 'roundEligibilityService.dart';
import 'dart:async';
import 'emailService.dart';
import 'emailSendingControl.dart';
import 'roundFlow.dart';
import 'timerStateService.dart';

class RoundControlService {

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating UserService into an object
  UserService userService = UserService();

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //Instantiating RoundService into an object
  RoundService roundService = RoundService();

  //Instantiating EmailService into an object
  EmailService emailService = EmailService();

  //Instantiating EmailSendingControl into an object
  EmailSendingControl emailSendingControl = EmailSendingControl();

  //Instantiating TimerStateService into an object
  TimerStateService timerStateService = TimerStateService();

  //List of users
  List<User> users = [];

  //Timer object
  Timer? timer;

  //Round flow state
  RoundFlowState roundFlowState = RoundFlowState.idle;
  bool isProcessing = false;

  //Timer end time
  DateTime? endTime;

  Duration? lastRemaining;

  //Timer notification sending state flags
  bool threeMinuteNotificationSent = false;
  bool oneMinuteNotificationSent = false;

  //Instantiating RoundEligibilityService into an object
  RoundEligibilityService roundEligibilityService = RoundEligibilityService();

  //**Public Entry Point for Service Class**\\
  Future<void> startTurn() async {

    //Blocking turn start if any class-related process is active
    if(roundFlowState != RoundFlowState.idle) {
      return;
    }

    //Activating active turn state
    roundFlowState = RoundFlowState.turnActive;

    //Opening turn window
    await startWindow();
  }

  //**Timer Start**\\
  Future<void> startWindow() async {

    //Activating waiting window state
    roundFlowState = RoundFlowState.waitingWindow;

    //Notification flags
    threeMinuteNotificationSent = false;
    oneMinuteNotificationSent = false;

    //Timer ends in 5 minutes
    endTime = DateTime.now().add(Duration(minutes: 5));

    timer?.cancel();

    //Checking how much time is left every second
    timer = Timer.periodic(Duration(seconds: 1), 
      (timer) async {

        //Time remaining
        if (endTime == null) return;
        final Duration remainingTime = endTime!.difference(DateTime.now());

        print("Remaining: ${remainingTime.inSeconds}");

        handleTick(remainingTime);
      }
    );
  }

  //**Timer Tick**\\
  void handleTick(Duration remainingTime) async {

    //Blocking method call if the a user is not in their waiting window for selecting a week
    if(roundFlowState != RoundFlowState.waitingWindow) {
      return;
    }

    //3 minutes remaining
    if(!threeMinuteNotificationSent && remainingTime.inSeconds <= 180) {
      threeMinuteNotificationSent = true;
      print("3 minute notification");

      //Sending email reminder 
      emailSendingControl.emailReminderToPick(remainingTime.inSeconds);
    }

    //1 minute remaining
    if(!oneMinuteNotificationSent && remainingTime.inSeconds <= 60) {
      oneMinuteNotificationSent = true;
      print("1 minute notification");

      //Sending email reminder
      emailSendingControl.emailReminderToPick(remainingTime.inSeconds);
    }

    //End of window
    if (remainingTime <= Duration.zero) {
      timer?.cancel();
      timer = null;
      
      //Sending an email to inform the user that their window to select a week has closed
      await emailSendingControl.emailToInformOfWindowClosure();

      transition();
    }
  }

  //State transition
  Future<void> transition() async {

    if(isProcessing) {
      return;
    }

    //Updating state
    isProcessing = true;
    roundFlowState = RoundFlowState.processingTransition;

    try {
      print("TRANSITION START");

      await turnProgressionHandler();
      roundFlowState = RoundFlowState.turnActive;

      await startWindow();
    } finally {
      isProcessing = false;
    }
  }

  //Method to start a round
  Future<void> startRound(int roundNumber) async {

    //Ending timer
    endTimer();

    //Updating current round number
    await systemStateService.updateCurrentRoundNum(sysStateId: 1, currentRoundNumber: roundNumber);

    //Updating round state
    await roundService.updateRound(roundNumber: roundNumber, isActive: true);

    //Entry point
    await startTurn();

    //Notifying the first priority user that it's their turn to select a week
    await emailSendingControl.emailNotificationOfTurnStart();
  }



  //Method to handle turn progression
  Future<void> turnProgressionHandler() async {

    print("=== TURN PROGRESSION START ===");

    endTimer();

    //System state
    SystemState systemState = await systemStateService.getSystemState();

    //Current round
    int currentRound = systemState.currentRoundNumber;

    //Loading all users
    List<User> allUsers = await userRepository.loadRecords();

    //Creating a sorted list of regular round participants
    List<User> regularUsers = allUsers.where((user) => (user.priorityNumber ?? 0) > 0).toList();
    regularUsers.sort((a, b) => a.priorityNumber!.compareTo(b.priorityNumber!));

    //Creating a sorted list of prepick round participants
    List<User> prepickUsers = allUsers.where((user) => (user.prepicksPriorityNumber ?? 0) > 0).toList();
    prepickUsers.sort((a, b) => a.prepicksPriorityNumber!.compareTo(b.prepicksPriorityNumber!));

    //List of either regular round or prepick participants based on current round number
    if(currentRound > 0) {
      users = regularUsers;
    } else {
      users = prepickUsers;
    }

    //Lists to hold a user's round and prepick eligibility statuses
    Map<int, List<bool>> roundEligibilityByUser = {};
    Map<int, List<bool>> prepickEligibilityByUser = {};

    for (User user in users) {

      //Determining user's round eligibility
      roundEligibilityByUser[user.id] = roundEligibilityService.computeRoundEligibility(user.weeksAllowed);

      //Determining user's prepicks eligibility
      prepickEligibilityByUser[user.id] = roundEligibilityService.computePrepickEligibility(user.prepicksAllowed);
    }

    //Maximum turn priority number
    int maxTurnPriority = users.length;

    //Next turn priority
    int nextPriority = systemState.currentTurnPriority + 1;

    print("Users: ${users.length}");

    print("Current round: ${systemState.currentRoundNumber}");
    print("Current priority: ${systemState.currentTurnPriority}");

    print("Next priority: $nextPriority");
    print("Max priority: $maxTurnPriority");

    while(nextPriority <= maxTurnPriority) {

      print("Checking priority $nextPriority");

      User user = users[nextPriority - 1];

      if (currentRound < 1) {
        print("User ${user.id} prepicksPriority=${user.prepicksPriorityNumber}");
      } else {
        print("User ${user.id} priority=${user.priorityNumber}");
      }

      bool canPick;

      //Prepick rounds
      if(currentRound < 1) {
        int prepickIndex = currentRound + 1;

        //Determining eligibility
        canPick = prepickEligibilityByUser[user.id]![prepickIndex];
      }

      //Normal rounds
      else {

        //Determining eligibility
        canPick = roundEligibilityByUser[user.id]![currentRound - 1];
      }

      if(canPick) {

        print("UPDATING TO PRIORITY $nextPriority");

        await systemStateService.updateCurrentTurnPriorityNumber(sysStateId: 1, currentTurnPriority: nextPriority);

        SystemState updatedState = await systemStateService.getSystemState();

        print("DB PRIORITY AFTER UPDATE: ${updatedState.currentTurnPriority}");

        await emailSendingControl.emailNotificationOfTurnStart();

        return;
      }
      nextPriority++;
    }
    await roundService.updateRound(roundNumber: currentRound, isActive: false);
    await roundService.updateRoundActivity(roundNumber: currentRound, isComplete: true);
    await systemStateService.updateCurrentTurnPriorityNumber(sysStateId: 1, currentTurnPriority: 1);
  }


  //Method to end the timer
  void endTimer() {
    print("END TIMER INSTANCE: $hashCode");
    print("TIMER BEFORE CANCEL: $timer");

    timer?.cancel();
    timer = null;
    endTime = null;

    lastRemaining = null;

    threeMinuteNotificationSent = false;
    oneMinuteNotificationSent = false;

    print("Timer ended");
  }

   void dispose() {
    timer?.cancel();
    timer = null;
  }
}