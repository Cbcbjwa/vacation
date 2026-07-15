/*
*Ella Muro
*23 April 2026
*Class to Handle Login Authorization
*/

//Imports section
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'secureStorageService.dart';

class AuthService {

 final SecureStorageService secureStorage = SecureStorageService();

  //Fields of the class
  final String baseUrl = "https://vacation-xhxd.onrender.com";

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
      print("label2: ${data["user"]["label2"]}");

    if(data["success"]) {

      //Saving tokens
      await secureStorage.saveAccessToken(data["accessToken"]);
      await secureStorage.saveRefreshToken(data["refreshToken"]);

      return User.fromJson(data["user"]);
    }
  }

  print("STATUS CODE: ${response.statusCode}");
  print("BODY: ${response.body}");

  
  return null;
  }

  //Refresh method
  Future<User?> refresh() async {

    final refreshToken = await secureStorage.getRefreshToken();

    if (refreshToken == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse("$baseUrl/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "refreshToken": refreshToken,
      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      await secureStorage.saveAccessToken(
        data["accessToken"],
      );

      return User.fromJson(data["user"]);
    }

    return null;
  }

  //Method to log users out of the app
  Future<void> logout() async {

    final refreshToken = await secureStorage.getRefreshToken();

    if (refreshToken != null) {

      await http.post(
        Uri.parse("$baseUrl/auth/logout"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "refreshToken": refreshToken,
        }),
      );

    }

    //Deleting tokens
    await secureStorage.deleteAccessToken();
    await secureStorage.deleteRefreshToken();
  }
}