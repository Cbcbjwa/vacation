/*
*Ella Muro
*7 May 2026
*Class to Represent the Weeks of the Year
*/

class Week {

  //**Fields of the Class**\\
  int weekId;
  int weekNumber;
  String weekDate;
  int? availableSlots;
  String? specialSpecification;
  int totalSlots;
  
  
  //**Constructor Section**\\

  //Default constructor
  Week()
    : weekId = 1,
      weekNumber = 1,
      weekDate = "1/4-1/8",
      availableSlots = 3,
      specialSpecification = "Spring Break",
      totalSlots = 8;
      

  //Full constructor
  Week.full({required this.weekId, required this.weekNumber, required this.weekDate, this.availableSlots, this.specialSpecification, required this.totalSlots});

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week.full(
      weekId: json["weekId"],
      weekNumber: json["weekNumber"],
      weekDate: json["weekDate"],
      availableSlots: json["availableSlots"],
      specialSpecification: json["specialSpecification"],
      totalSlots: json["totalSlots"]
    );
  }
}