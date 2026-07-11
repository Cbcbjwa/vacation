/*
*Ella Muro
*7 May 2026
*Class to Represent the Selections of Vacation Weeks
*/

class Selection {

  //**Fields of the Class**\\
  int selectionId;
  int userId;
  int weekId;
  int roundNumber;

  //**Constructor Section**\\

  //Default constructor
  Selection()
    : selectionId = 1,
      userId = 1,
      weekId = 1,
      roundNumber = 1;

  //Full constructor
  Selection.full({required this.selectionId, required this.userId, required this.weekId, required this.roundNumber});

  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection.full(
      selectionId: json["selectionId"],
      userId: json["userId"],
      weekId: json["weekId"],
      roundNumber: json["roundNumber"]
    );
  }

  //**Getters and Setters**\\
   int getSelectionId() {
    return selectionId;
  }

  void setSelectionId(int selectionId) {
    this.selectionId = selectionId;
  }
}