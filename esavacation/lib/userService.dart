/*
*Ella Muro
*29 April 2026
*Class to Handle Users
*/

//Imports section
import 'user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'role.dart';
import 'connectivityService.dart';

class UserService {
  final String baseUrl = "https://vacation-xhxd.onrender.com";

    //Method for loading users
    Future<List<User>> getUsers() async {

      try {
        final res = await http.get(Uri.parse("$baseUrl/users"));

        print("STATUS: ${res.statusCode}");
        print("BODY: ${res.body}");

        if(res.statusCode == 200) {
          final List data = jsonDecode(res.body);

          print(res.body);

          return data.map((e) => User.fromJson(e)).toList();
        }
        return [];
    } catch (error) {
      print("GET USERS ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for creating users
  Future<bool> createUser({
    required String userName,
    required String email,
    required String password,
    required String docRole,
    required int weeksAllowed,
    required int prepicksAllowed,
    int? priorityNumber,
    int? prepicksPriorityNumber,
    String? label,
    required String displayName,
    required String phoneNumber,
    String? label2
  }) async {

    try {

    print("SENDING CREATE USER REQUEST...");

    final res = await http.post(
      Uri.parse("$baseUrl/users/register"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "userName": userName,
        "email": email,
        "password": password,
        "docRole": docRole,
        "weeksAllowed": weeksAllowed,
        "prepicksAllowed": prepicksAllowed,
        "priorityNumber": priorityNumber,
        "prepicksPriorityNumber": prepicksPriorityNumber,
        "label": label,
        "displayName": displayName,
        "phoneNumber": phoneNumber,
        "label2": label2
      }),
    ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("CREATE USER ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for updating users
  Future<bool> updateUser({
    required int id,
    required String userName,
    required String email,
    required Role docRole,
    required int weeksAllowed, 
    required int prepicksAllowed,
    int? priorityNumber,
    int? prepicksPriorityNumber,
    String? label,
    required String displayName,
    required String phoneNumber,
    String? label2
  }) async {
    print ("UPDATING USER...");

    try {

    final res = await http.put(
      Uri.parse("$baseUrl/users/update"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "id": id,
        "userName": userName,
        "email": email,
        "docRole": docRole.name,
        "weeksAllowed": weeksAllowed,
        "prepicksAllowed": prepicksAllowed,
        "priorityNumber": priorityNumber,
        "prepicksPriorityNumber": prepicksPriorityNumber,
        "label": label,
        "displayName": displayName,
        "phoneNumber": phoneNumber,
        "label2": label2
      }),
    ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("UPDATE USER ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for deleting a user
  Future<bool> deleteUserRecord({
    required int id,
  }) async {

    try {
        print("DELETING USER...");

        final res = await http.delete(
          Uri.parse("$baseUrl/users/$id"),
        ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;

    } catch (error) {
      print("DELETE USER ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for changing password
  Future<String> changePassword ({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    print("UPDATING PASSWORD..");

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/users/updatePassword"),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "userId": userId,
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      ).timeout(Duration(seconds: 15));

      if(response.statusCode == 200) {
        return "Success";
      }

      final data = jsonDecode(response.body);
      return data["error"] ?? "Failed to change password";

    } catch (error) {
      ConnectivityService.instance.connectionFailed();
      return "Failed to connect to server";
    }
  }
}