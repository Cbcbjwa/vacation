/*
*Ella Muro
*6 June 2026
*Class to Handle Rounds
*/

//Imports section
import 'round.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoundService {
  //final String baseUrl = "http://10.0.2.2:3000";
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading users
  Future<List<Round>> getRounds() async {
    final res = await http.get(Uri.parse("$baseUrl/rounds"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      print(res.body);

      return data.map((e) => Round.fromJson(e)).toList();
    }
    return [];
  }

  //Method for updating a round
  Future<bool> updateRound({
    required int roundNumber,
    required bool isActive,
  }) async {
    print ("UPDATING ROUND");

    final res = await http.put(
      Uri.parse("$baseUrl/rounds/update"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "roundNumber": roundNumber,
        "isActive": isActive
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for updating a round's activity state
  Future<bool> updateRoundActivity({
    required int roundNumber,
    required bool isComplete,
  }) async {
    print ("UPDATING ROUND");

    final res = await http.put(
      Uri.parse("$baseUrl/rounds/updateActivity"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "roundNumber": roundNumber,
        "isComplete": isComplete
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }
}