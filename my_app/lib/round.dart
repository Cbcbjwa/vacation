/*
*Ella Muro
*7 May 2026
*Class to Represent the Rounds for Selecting Vacation Weeks
*/

class Round {

  //**Fields of the Class**\\
  int roundId;
  int roundNumber;
  String roundName;

  //**Constructor Section**\\

  //Full constructor
  Round.full({required this.roundId, required this.roundNumber, required this.roundName});

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round.full(
      roundId: json["roundId"],
      roundNumber: json["roundNumber"],
      roundName: json["roundName"]
    );
  }

  //**Getters and Setters**\\
   int getRoundId() {
    return roundId;
  }

  void setRoundId(int roundId) {
    this.roundId = roundId;
  }

}