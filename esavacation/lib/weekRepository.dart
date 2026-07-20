/*
*Ella Muro
*20 May 2026
*Repository to Hold the Master List of Weeks
*/

//Imports section
import 'package:flutter/material.dart';
import 'week.dart';
import 'weekService.dart';
import 'connectivityService.dart';

class WeekRepository {

  //Instantiating WeekService class into an object
  WeekService weekService = WeekService();
 

  //Initializing a master list of all the weeks of the year
  List<Week> weeks = [];

  //Method to load weeks
  Future<List<Week>> loadWeekRecords() async {

    try {
      weeks = await weekService.getWeeks();

      print("WEEKS LENGTH: ${weeks.length}");
      print("RAW WEEKS: $weeks");

      return weeks;
    } catch (error) {
      print("WEEK REPOSITORY ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("Unable to load weeks");
    }
  }
}