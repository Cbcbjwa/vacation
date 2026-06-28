/*
*Ella Muro
*25 June 2026
*Class to Handle Timer State
*/

//Imports section
import 'timerState.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimerStateService {
  final String baseUrl = "http://10.0.2.2:3000";

  //Method for loading the timer state
  Future<TimerState> getTimerState() async {
    final res = await http.get(Uri.parse("$baseUrl/timerState"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      print(res.body);

      return TimerState.fromJson(data.first);
    }
    throw Exception("Failed to load timer state");
  }

  //Method for updating the timer state
  Future<bool> updateTimerState({
    required int timerStateId,
    required bool timerIsActive,
    DateTime? turnEndTime
  }) async {
    print ("UPDATING TIMER STATE...");

    final res = await http.put(
      Uri.parse("$baseUrl/timerState/update"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "timerStateId": timerStateId,
        "timerIsActive": timerIsActive,
        "turnEndTime": turnEndTime?.toIso8601String()
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }
}