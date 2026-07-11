/*
*Ella Muro
*8 May 2026
*Repository to Hold the Master List of Users
*/

//Imports section
import 'package:flutter/material.dart';
import 'user.dart';
import 'userService.dart';

class UserRepository {

  //Instantiating UserService class into an object
  UserService userService = UserService();

  //Initializing a master list of all the weeks of the year
  List<User> users = [];

  //Method to load users
  Future<List<User>> loadRecords() async {
    users = await userService.getUsers();

    print("FIRST USER: ${users.isNotEmpty ? users[0].userName : 'EMPTY'}");
    print("USERS LENGTH: ${users.length}");
    print("RAW USERS: $users");

    return users;
  }
}