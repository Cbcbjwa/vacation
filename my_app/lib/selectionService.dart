/*
*Ella Muro
*26 May 2026
*Class to Handle Selections
*/

//Imports section
import 'selection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SelectionService {
   final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading selections
  Future<List<Selection>> getSelections() async {
    final res = await http.get(Uri.parse("$baseUrl/selections"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {

      final data = jsonDecode(res.body);

      final List selections = data["selections"];

      return selections
        .map((e) => Selection.fromJson(e))
        .toList();
  }
    return [];
  }

  //Method for creating selections
  Future<Selection> createSelection({
    required int userId,
    required int weekId,
    required int roundNumber,
  }) async {

    print ("SENDING CREATE SELECTION REQUEST");

    final res = await http.post(
      Uri.parse("$baseUrl/selections/addSelection"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "userId": userId,
        "weekId": weekId,
        "roundNumber": roundNumber,
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  
  final data = jsonDecode(res.body);

  if (res.statusCode != 200 || data["success"] != true) {
    throw Exception(data["message"] ?? "Failed to create selection");
  }

  return Selection.fromJson(data["selection"]);
  }

  //Method for updating selections
  Future<bool> updateSelection({
    required int selectionId,
    required int weekId,
  }) async {
    print ("UPDATING SELECTION");

    final res = await http.put(
      Uri.parse("$baseUrl/selections/update"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "selectionId": selectionId,
        "weekId": weekId,
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

   //Method for deleting a selection
  Future<bool> deleteSelectionRecord({

    required int selectionId,

  }) async {
    print("DELETING SELECTION...");

    final res = await http.delete(
      Uri.parse("$baseUrl/selections/$selectionId"),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for getting a SINGULAR selection
  Future<Selection?> getSelection({
  required int userId,
  required int roundNumber,
  }) async {

    final res = await http.get(
      Uri.parse("$baseUrl/selections/user/$userId/round/$roundNumber"),
    );

    print("GET SELECTION STATUS: ${res.statusCode}");
    print("GET SELECTION BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to load selection");
    }

    final data = jsonDecode(res.body);

    if (data["selection"] == null) {
      return null;
    }

    return Selection.fromJson(data["selection"]);
  }

  //Method for loading the selections of an individual user
  Future<List<Selection>> getSelectionsByUser(int userId) async {

    final res = await http.get(
      Uri.parse("$baseUrl/selections/user/$userId"),
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(res.body);

    final List selections = data["selections"];

    return selections
        .map((e) => Selection.fromJson(e))
        .toList();
  }
}