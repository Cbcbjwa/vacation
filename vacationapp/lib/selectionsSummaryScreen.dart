/*
*Ella Muro
*7 May 2026
*Selections Summary UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'selectionService.dart';
import 'session.dart';
import 'selection.dart';
import 'week.dart';
import 'weekRepository.dart';

class SelectionsSummaryScreen extends StatefulWidget {
  const SelectionsSummaryScreen({super.key});

  @override
  State<SelectionsSummaryScreen> createState() => _SelectionsSummaryScreenState();

}

class _SelectionsSummaryScreenState extends State<SelectionsSummaryScreen> {

  //Instantiating SelectionService into an object
  SelectionService selectionService = SelectionService();

  //Instantiating WeekRepository into an object
  WeekRepository weekRepository = WeekRepository();

  //List of user's selections
  List<Selection> weekSelections = [];

  //List of weeks
  List<Week> weeks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  //Method to load selections and weeks
  Future<void> load() async {
    weekSelections = await selectionService.getSelectionsByUser(Session.userId!);
    weeks = await weekRepository.loadWeekRecords();
    setState(() {
      isLoading = false;
    });
  }

  //Method for building the selections summary
  String buildSummary(){
  return weekSelections.map((selection) {

      final matchingWeeks = weeks.where((week) => week.weekId == selection.weekId).toList();

      if(matchingWeeks.isEmpty) {
        return "Round ${selection.roundNumber}: N/A";
      }

      final week = matchingWeeks.first;

      if(selection.roundNumber >= 1) {
        return "Round ${selection.roundNumber}:    Week ${week.weekNumber}  (${week.weekDate})";
      }

      if(selection.roundNumber == -1) {
        return "Prepicks 1:    Week ${week.weekNumber}  (${week.weekDate})";
      }

      if(selection.roundNumber == 0) {
        return "Prepicks 2:    Week ${week.weekNumber}  (${week.weekDate})";
      }
      

    }).join("\n\n");

  }

  @override
  Widget build(BuildContext context) {

    if(isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
  
        body: Center(
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 40, 89, 113),
        ),
        )
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Selections Summary",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 70),

          child: Container(
            padding: EdgeInsets.all(20),
          

            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueGrey,
                width: 2
              ),

              borderRadius: BorderRadius.circular(12),
            ),
          

            child: weekSelections.isEmpty
            ? Text("N/A",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            )

            : Text(
              buildSummary(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            )
          )
        )
      )
    );
  }
}