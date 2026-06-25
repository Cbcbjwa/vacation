/*
*Ella Muro
*25 June 2026
*Class to Represent the System-Wide Timer State
*/

class TimerState {

  //Fields of the class
  int timerId;
  bool timerIsActive;
  DateTime turnEndTime;

  //Constructor
  TimerState.full({required this.timerId, required this.timerIsActive, required this.turnEndTime});

  factory TimerState.fromJson(Map<String, dynamic> json) {
    return TimerState.full(
      timerId: json["timerId"],
      timerIsActive: json["timerIsActive"], 
      turnEndTime: json["turnEndTime"]
    );
  }

}