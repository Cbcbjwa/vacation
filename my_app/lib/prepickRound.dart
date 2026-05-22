/*
*Ella Muro
*11 May 2026
*Class to Represent the Prepick Rounds for Selecting Vacation Weeks
*/

class PrepickRound {

  //**Fields of the Class**\\
  int prepickRoundId;
  int prepickRoundNumber;
  bool isOpen;
  int currentTurnPriority;
  int slotsPerWeek;

  //**Constructor Section**\\

  //Default constructor
  PrepickRound()
    : prepickRoundId = 1,
      prepickRoundNumber = 1,
      isOpen = false,
      currentTurnPriority = 1,
      slotsPerWeek = 3;

  //Full constructor
  PrepickRound.full({required this.prepickRoundId, required this.prepickRoundNumber, required this.isOpen, required this.currentTurnPriority, required this.slotsPerWeek});

  //**Getters and Setters**\\
   int getPrepickRoundId() {
    return prepickRoundId;
  }

  void setPrepickRoundId(int prepickRoundId) {
    this.prepickRoundId = prepickRoundId;
  }

}