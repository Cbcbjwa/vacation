/*
*Ella Muro
*20 May 2026
*Repository to Hold the Master List of Weeks
*/

//Imports section
import 'package:flutter/material.dart';
import 'week.dart';
import 'weekService.dart';

class WeekRepository {

  //Instantiating WeekService class into an object
  WeekService weekService = WeekService();
 

  //Initializing a master list of all the weeks of the year
  List<Week> weeks = [];

  //Method to load weeks
  Future<List<Week>> loadWeekRecords() async {
    weeks = await weekService.getWeeks();

    print("WEEKS LENGTH: ${weeks.length}");
    print("RAW WEEKS: $weeks");

    return weeks;
  }
}