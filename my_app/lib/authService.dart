/*
*Ella Muro
*23 April 2026
*Class to Handle Login Authorization
*/

//Imports section
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';


class AuthService {

  //Fields of the class
  final String baseUrl = "http://10.0.2.2:3000";

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    //Checking for a response from the API
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print("id: ${data["user"]["id"]}");
      print("name: ${data["user"]["userName"]}");
      print("email: ${data["user"]["email"]}");
      print("role: ${data["user"]["docRole"]}");
      print("weeksAllowed: ${data["user"]["weeksAllowed"]}");
      print("prepicksAllowed: ${data["user"]["prepicksAllowed"]}");
      print("priorityNumber: ${data["user"]["priorityNumber"]}");
      print("prepicksPriorityNumber: ${data["user"]["prepicksPriorityNumber"]}");
      print("label: ${data["user"]["label"]}");

    if(data["success"]) {
      return User.fromJson(data["user"]);
    }
  }

  print("STATUS CODE: ${response.statusCode}");
  print("BODY: ${response.body}");

  
  return null;
  }
}