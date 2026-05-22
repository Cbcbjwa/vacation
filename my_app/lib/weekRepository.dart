/*
*Ella Muro
*20 May 2026
*Repository to Hold the Master List of Weeks
*/

//Imports section
import 'package:flutter/material.dart';
import 'week.dart';
import 'userService.dart';

class WeekRepository {

  //Instantiating UserService class into an object
  UserService userService = UserService();

  //Initializing a master list of all the weeks of the year
  List<Week> weeks = [];
}