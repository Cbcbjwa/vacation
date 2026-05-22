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

class UserService {
  final String baseUrl = "http://10.0.2.2:3000";

  //Method for loading users
  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse("$baseUrl/users"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      print(res.body);

      return data.map((e) => User.fromJson(e)).toList();
    }
    return [];
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
  }) async {

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
      }),
    );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
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
  }) async {
    print ("UPDATING USER...");

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
      }),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for deleting a user
  Future<bool> deleteUserRecord({
    required int id,
  }) async {
    print("DELETING USER...");

    final res = await http.delete(
      Uri.parse("$baseUrl/users/$id"),
    );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }
}