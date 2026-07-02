/*
*Ella Muro
*1 July 2026
*Class to Handle Lottery Service Methods
*/

//Imports section
import 'dart:convert';
import 'package:http/http.dart' as http;

class LotteryService {
    final String baseUrl = "https://vacation-xhxd.onrender.com";

    //Method for starting a round
    Future<bool> startRound({
      required int roundNumber,
    }) async {

      final res = await http.post(
        Uri.parse("$baseUrl/lottery/startRound"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "roundNumber": roundNumber,
        }),
      );

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
  }

  //Method to advance the next user's turn
  Future<bool> advanceTurn() async {

    final res = await http.post(
      Uri.parse("$baseUrl/lottery/advanceTurn"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return res.statusCode == 200;
  }

  //Method to end the timer
  Future<bool> endTimer() async {

    final res = await http.post(
      Uri.parse("$baseUrl/lottery/endTimer"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return res.statusCode == 200;
  }
}