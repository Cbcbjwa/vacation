/*
*Ella Muro
*22 May 2026
*Class to Handle Weeks
*/

//Imports section
import 'week.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeekService {
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading users
  Future<List<Week>> getWeeks() async {
    final res = await http.get(Uri.parse("$baseUrl/weeks"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      print(res.body);

      return data.map((e) => Week.fromJson(e)).toList();
    }
    return [];
  }

  //Method for creating weeks
  Future<bool> createWeek({
    required int weekNumber,
    required String weekDate,
    String? specialSpecification,
    required int totalSlots,
  }) async {

    print ("SENDING CREATE WEEK REQUEST");

    final res = await http.post(
      Uri.parse("$baseUrl/weeks/addWeek"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "weekNumber": weekNumber,
        "weekDate": weekDate,
        "specialSpecification": specialSpecification,
        "totalSlots": totalSlots,
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for updating weeks
  Future<bool> updateWeek({
    required int weekId,
    required int weekNumber,
    required String weekDate,
    String? specialSpecification,
    required int totalSlots,
  }) async {
    print ("UPDATING WEEK");

    final res = await http.put(
      Uri.parse("$baseUrl/weeks/update"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "weekId": weekId,
        "weekNumber": weekNumber,
        "weekDate": weekDate,
        "specialSpecification": specialSpecification,
        "totalSlots": totalSlots,
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for deleting a week
  Future<bool> deleteWeekRecord({

    required int weekId,

  }) async {
    print("DELETING WEEK...");

    final res = await http.delete(
      Uri.parse("$baseUrl/weeks/$weekId"),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }
}