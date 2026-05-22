/*
*Ella Muro
*7 May 2026
*Class to Represent the Rounds for Selecting Vacation Weeks
*/

class Round {

  //**Fields of the Class**\\
  int roundId;
  int roundNumber;
  bool isOpen;
  int currentTurnPriority;
  int slotsPerWeek;

  //**Constructor Section**\\

  //Default constructor
  Round()
    : roundId = 1,
      roundNumber = 1,
      isOpen = false,
      currentTurnPriority = 1,
      slotsPerWeek = 8;

  //Full constructor
  Round.full({required this.roundId, required this.roundNumber, required this.isOpen, required this.currentTurnPriority, required this.slotsPerWeek});

  //**Getters and Setters**\\
   int getRoundId() {
    return roundId;
  }

  void setRoundId(int roundId) {
    this.roundId = roundId;
  }

}