/*
*Ella Muro
*7 May 2026
*Class to Represent the Weeks of the Year
*/

class Week {

  //**Fields of the Class**\\
  int weekId;
  int weekNumber;
  String date;
  int? availableSlots;
  String? specialSpecification;
  
  
  //**Constructor Section**\\

  //Default constructor
  Week()
    : weekId = 1,
      weekNumber = 1,
      date = "1/4-1/8",
      availableSlots = 3,
      specialSpecification = "Spring Break";
      

  //Full constructor
  Week.full({required this.weekId, required this.weekNumber, required this.date, this.availableSlots, this.specialSpecification});

}