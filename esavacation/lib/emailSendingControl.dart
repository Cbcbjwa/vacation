/*
*Ella Muro
*21 June 2026
*Class to Handle Sending Emails
*/

//Imports section
import 'emailService.dart';
import 'user.dart';
import 'userRepository.dart';
import 'systemState.dart';
import 'systemStateService.dart';
import 'round.dart';
import 'roundService.dart';

class EmailSendingControl {

  //Instantiating EmailService into an object
  EmailService emailService = EmailService();

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //Instantiating RoundService into an object
  RoundService roundService = RoundService();

  //System state
  SystemState? systemState;

  //List of users
  List<User> users = [];

  //List of rounds
  List<Round> rounds = [];

  //Current round
  Round? currentRound;

  //Current round name
  String? roundName;

  //User with an active turn
  User? userWithActiveTurn;

  //Method to load users and system state
  Future<void> load() async {

    //Loading users
    users = await userRepository.loadRecords();

    //Loading rounds
    rounds = await roundService.getRounds();

    //Loading system state
    systemState = await systemStateService.getSystemState();

    //Determining the name of the current round
    for(Round round in rounds) {
      if(round.roundNumber == systemState!.currentRoundNumber) {
        currentRound = round;
        break;
      }
    }
    roundName = currentRound?.roundName ?? "";

    //Determining which user has an active turn
    if(systemState!.currentRoundNumber < 1) {

      //Active user during prepicks
      userWithActiveTurn = users.firstWhere((user) => user.prepicksPriorityNumber == systemState!.currentTurnPriority, orElse: () => users.first);
    } else {

      //Active user during regular rounds
      userWithActiveTurn = users.firstWhere((user) => user.priorityNumber == systemState!.currentTurnPriority, orElse: () => users.first);
    }
  }


  //**Email Sending Methods**\\

  //Method to send an email to inform the user that their turn has begun
  Future<void> emailNotificationOfTurnStart() async {

    //Loading everything
    await load();

    print("Sending to: ${userWithActiveTurn!.email}");

    //Sending the email
    await emailService.sendEmail(to: userWithActiveTurn!.email, subject: "Your Turn", text: "Your window is open to select a vacation week for $roundName of the 2027 ESA Vacation Lottery.\nYou have 24 hours to confirm your selection. Please use the ESA Vacation App to review available weeks and make your selection. After 24 hours, your window will be closed, and you will need to contact your administrator to secure a week for this round.");
  }

  //Method to send an email to remind the user to make a selection
  Future<void> emailReminderToPick(int timeRemaining) async {

    //Loading everything
    await load();

    print("Sending to: ${userWithActiveTurn!.email}");

    //Sending the email
    await emailService.sendEmail(to: userWithActiveTurn!.email, subject: "**REMINDER**", text: "Your time-limited window for selecting a week for $roundName of the 2027 ESA Vacation Lottery is open. You have $timeRemaining hours to confirm your week. If you are having difficulties, or would prefer not to use the ESA Vacation App, please reach out to an administrator between the hours of 6am to 10pm for assistance.");
  }

  //Method to send an email to inform the user that their window to select a week has closed
  Future<void> emailToInformOfWindowClosure() async {

    //Loading everything
    await load();

    print("Sending to: ${userWithActiveTurn!.email}");

    //Sending the email
    await emailService.sendEmail(to: userWithActiveTurn!.email, subject: "Your Window has Closed", text: "Your window to select a vacation week has closed. Please reach out to an administrator between the hours of 6am and 10pm to confirm a week for $roundName.");
  }
}