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

class RoundControlService {

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating UserService into an object
  UserService userService = UserService();

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //Instantiating RoundService into an object
  RoundService roundService = RoundService();

  //Instantiating RoundEligibilityService into an object
  RoundEligibilityService roundEligibilityService = RoundEligibilityService();

  //Method to start a round
  Future<void> startRound(int roundNumber) async {
    await systemStateService.updateCurrentRoundNum(sysStateId: 1, currentRoundNumber: roundNumber);
    await roundService.updateRound(roundNumber: roundNumber, isActive: true);
  }

  //Method to handle turn progression
  Future<void> turnProgressionHandler() async {

    //List of users
    List<User> users = userRepository.users;
    
    users.sort((a, b) => a.priorityNumber!.compareTo(b.priorityNumber!));

    Map<int, List<bool>> roundEligibilityByUser = {};
    Map<int, List<bool>> prepickEligibilityByUser = {};

    for (User user in users) {

      //Determining round eligibility
      roundEligibilityByUser[user.id] = roundEligibilityService.computeRoundEligibility(user.weeksAllowed);

      //Determining prepicks eligibility
      prepickEligibilityByUser[user.id] = roundEligibilityService.computePrepickEligibility(user.prepicksAllowed);
    }

    //System state
    SystemState systemState = await systemStateService.getSystemState();

    //Current round
    int currentRound = systemState.currentRoundNumber;

    //Maximum turn priority number
    int maxTurnPriority = users.length;

    //Next turn priority
    int nextPriority = systemState.currentTurnPriority + 1;

    while(nextPriority <= maxTurnPriority) {

      User user = users[nextPriority - 1];

      bool canPick;

      //Prepick rounds
      if(currentRound < 1) {
        int prepickIndex = currentRound + 1;
        canPick = prepickEligibilityByUser[user.id]![prepickIndex];
      }

      //Normal rounds
      else {
        canPick = roundEligibilityByUser[user.id]![currentRound - 1];
      }

      if(canPick) {
        await systemStateService.updateCurrentTurnPriorityNumber(sysStateId: 1, currentTurnPriority: nextPriority);
        return;
      }
      nextPriority++;
    }
    await roundService.updateRound(roundNumber: currentRound, isActive: false);
    await roundService.updateRoundActivity(roundNumber: currentRound, isComplete: true);
  }
}