/*
*Ella Muro
*23 April 2026
*Class to Act as the Middleman Between the Login Screen UI and API Class
*/

//Imports section
import 'authService.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class LoginController {

  //Field of the class
  final AuthService authService;

  LoginController(this.authService);

  Future<User?> login(String email, String password) async {

    return await authService.login(email, password);
  }
}