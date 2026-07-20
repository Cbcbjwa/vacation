/*
*Ella Muro
*4 June 2026
*Class to Represent States of the System including Current Round and Current Turn Priority
*/

class SystemState {

  //Fields of the class
  int sysStateId;
  int currentRoundNumber;
  int currentTurnPriority;

  //Constructor
  SystemState.full({required this.sysStateId, required this.currentRoundNumber, required this.currentTurnPriority});

  factory SystemState.fromJson(Map<String, dynamic> json) {
    return SystemState.full(
      sysStateId: json["sysStateId"],
      currentRoundNumber: json["currentRoundNumber"],
      currentTurnPriority: json["currentTurnPriority"]
    );
  }
}