/*
*Ella Muro
*6 June 2026
*Class to Handle Rounds
*/

//Imports section
import 'round.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'connectivityService.dart';

class RoundService {
  //final String baseUrl = "http://10.0.2.2:3000";
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading rounds
  Future<List<Round>> getRounds() async {

    try {
      final res = await http.get(Uri.parse("$baseUrl/rounds")).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if(res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        print(res.body);

        return data.map((e) => Round.fromJson(e)).toList();
      }
      return [];
    } catch (error) {
      print("GET ROUNDS ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for updating a round
  Future<bool> updateRound({
    required int roundNumber,
    required bool isActive,
  }) async {

    try {
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
      ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("UPDATE ROUND IS ACTIVE ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for updating a round's activity state
  Future<bool> updateRoundActivity({
    required int roundNumber,
    required bool isComplete,
  }) async {

    try {
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
      ).timeout(Duration(seconds: 15));
      
      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("UPDATE ROUND IS COMPLETE ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }
}