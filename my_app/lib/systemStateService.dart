/*
*Ella Muro
*8 June 2026
*Class to Handle System State
*/

//Imports section
import 'systemState.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SystemStateService {
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading the system state
  Future<SystemState> getSystemState() async {
    final res = await http.get(Uri.parse("$baseUrl/sysState"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if(res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);

      return SystemState.fromJson(data);
    }

    throw Exception("Failed to load system state");
  }

  //Method for updating the current round number
  Future<bool> updateCurrentRoundNum({
    required int sysStateId,
    required int currentRoundNumber
  }) async {
    print ("UPDATING CURRENT ROUND NUMBER...");

    final res = await http.put(
      Uri.parse("$baseUrl/sysState/updateRoundNum"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "sysStateId": sysStateId,
        "currentRoundNumber": currentRoundNumber
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for updating the current turn priority
  Future<bool> updateCurrentTurnPriorityNumber({
    required int sysStateId,
    required int currentTurnPriority
  }) async {
    print ("UPDATING CURRENT TURN PRIORITY...");

    final res = await http.put(
      Uri.parse("$baseUrl/sysState/updateTurnPriority"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "sysStateId": sysStateId,
        "currentTurnPriority": currentTurnPriority
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

}