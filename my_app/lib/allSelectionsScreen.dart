/*
*Ella Muro
*29 May 2026
*UI for Displaying All Physician Selections
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'userRepository.dart';
import 'selectionService.dart';
import 'weekRepository.dart';
import 'selection.dart';
import 'week.dart';
import 'user.dart';

class AllSelectionsScreen extends StatefulWidget {
  const AllSelectionsScreen({super.key});

  @override
  State<AllSelectionsScreen> createState() => _AllSelectionsScreenState();
}

class _AllSelectionsScreenState extends State<AllSelectionsScreen> {

  //Instantiating WeekRepository into an object
  WeekRepository weekRepository = WeekRepository();

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating SelectionService into an object
  SelectionService selectionService = SelectionService();

  //List of selections
  List<Selection> selections = [];

  //List of weeks
  List<Week> weeks = [];

  //List of physicians
  List<User> physicians = [];

  //Method to load physicians, weeks, and selections
  Future<void> load() async {

    //Loading weeks
    final loadedWeeks = await weekRepository.loadWeekRecords();

    //Loading users
    final loadedPhysicians = await userRepository.loadRecords();

    //Loading selections
    final loadedSelections = await selectionService.getSelections();

    setState(() {
      weeks = loadedWeeks;
      physicians = loadedPhysicians;
      selections = loadedSelections;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {

    //Sorting physicians by priority number
    physicians.sort((a, b) => a.priorityNumber!.compareTo(b.priorityNumber!));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("All Physician Selections",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
          color: Colors.black,

          child: DataTable2(
            minWidth: 1500,
            fixedLeftColumns: 2,
            headingRowColor: WidgetStatePropertyAll(Colors.blueGrey),
            dataRowColor: WidgetStatePropertyAll(Colors.black),

            columnSpacing: 10,
            horizontalMargin: 6,

            columns: [

              const DataColumn2(
                fixedWidth: 58,
                label: Text(
                  "Priority",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const DataColumn2(
                fixedWidth: 130,
                label: Text(
                  "Physician",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ...List.generate(9, (index) {

                final roundNumber = index + 1;

                return DataColumn2(
                  fixedWidth: 100,

                  label: Center(
                    child: Text(
                      "Round $roundNumber",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                );
              }),
            ],

            rows: physicians.map((physician) {
              final physicianSelections = selections.where((selection) => selection.userId == physician.id).toList();

              String getRoundText(int roundNumber) {
                final matchingSelections = physicianSelections.where((selection) => selection.roundNumber == roundNumber).toList();

                if(matchingSelections.isEmpty) {
                  return "N/A";
                }

                final selection = matchingSelections.first;

                final matchingWeeks = weeks.where((week) => week.weekId == selection.weekId).toList();

                if(matchingWeeks.isEmpty) {
                  return "N/A";
                }

                final week = matchingWeeks.first;

                return "Wk ${week.weekNumber} \n ${week.weekDate}";
              }

              Widget buildRoundCell(int roundNumber) {

                final text = getRoundText(roundNumber);

                final isNA = text == "N/A";

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),

                  alignment: Alignment.center,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),

                  decoration: BoxDecoration(
                    color: isNA
                      ? const Color.fromARGB(255, 35, 34, 34)
                      : Colors.green,

                    borderRadius: BorderRadius.circular(3),
                  ),

                  child: Text(
                    text,
                    style: TextStyle(
                      color: isNA
                        ? Colors.grey
                        : Colors. white,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return DataRow2(
                cells: [
                  DataCell(
                    Center(
                      child: Text(
                        physician.priorityNumber.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    Text(
                      physician.displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  ...List.generate(9, (index) {
                    final roundNumber = index + 1;

                    return DataCell(
                      buildRoundCell(roundNumber),
                    );
                  }),
                ],
              );
            }).toList(),
          ),
        ),
    );
  }
}
