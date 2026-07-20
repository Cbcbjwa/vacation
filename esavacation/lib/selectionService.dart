/*
*Ella Muro
*26 May 2026
*Class to Handle Selections
*/

//Imports section
import 'selection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'connectivityService.dart';

class SelectionService {
   final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading selections
  Future<List<Selection>> getSelections() async {

    try {

      final res = await http.get(Uri.parse("$baseUrl/selections")).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if(res.statusCode == 200) {

          final data = jsonDecode(res.body);

          final List selections = data["selections"];

          return selections
            .map((e) => Selection.fromJson(e))
            .toList();
      }
      return [];
    } catch (error) {
      print("GET SELECTIONS ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for creating selections
  Future<Selection> createSelection({
    required int userId,
    required int weekId,
    required int roundNumber,
  }) async {

    try {
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
      ).timeout(Duration(seconds: 15));
      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

    
      final data = jsonDecode(res.body);

      if (res.statusCode != 200 || data["success"] != true) {
        throw Exception(data["message"] ?? "Failed to create selection");
      }

      return Selection.fromJson(data["selection"]);
    } catch (error) {
      print("CREATE SELECTION ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for updating selections
  Future<bool> updateSelection({
    required int selectionId,
    required int weekId,
  }) async {

    try {
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
      ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("UPDATE SELECTION ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for deleting a selection
  Future<bool> deleteSelectionRecord({

    required int selectionId,

  }) async {

    try {
      print("DELETING SELECTION...");

      final res = await http.delete(
        Uri.parse("$baseUrl/selections/$selectionId"),
      ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("DELETE SELECTION ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for getting a SINGULAR selection
  Future<Selection?> getSelection({
  required int userId,
  required int roundNumber,
  }) async {

    try {

      final res = await http.get(
        Uri.parse("$baseUrl/selections/user/$userId/round/$roundNumber"),
      ).timeout(Duration(seconds: 15));

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
    } catch (error) {
      print("GET SELECTION ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for loading the selections of an individual user
  Future<List<Selection>> getSelectionsByUser(int userId) async {

    try {

      final res = await http.get(
        Uri.parse("$baseUrl/selections/user/$userId"),
      ).timeout(Duration(seconds: 15));

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
    } catch (error) {
      print("GET SELECTIONS BY USER ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method to delete all selections upon a lottery reset
  Future<bool> deleteAllSelections() async {

    try {

      print("DELETING ALL SELECTIONS...");

      final res = await http.delete(
        Uri.parse("$baseUrl/selections/deleteEverySelection"),
      );

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("DELETE ALL SELECTIONS ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }
}