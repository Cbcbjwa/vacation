/*
*Ella Muro
*28 May 2026
*Selection Statistics UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'week.dart';
import 'weekService.dart';
import 'weekRepository.dart';

class SelectionStatsScreen extends StatefulWidget {
  const SelectionStatsScreen({super.key});

  @override
  State<SelectionStatsScreen> createState() => _SelectionStatsScreenState();
}

class _SelectionStatsScreenState extends State<SelectionStatsScreen> {

  //Instantiating WeekRepository into an object
  WeekRepository weekRepository = WeekRepository();

  //List of weeks
  List<Week> weeks = [];

  //Variable to store total slots
  int totalSlots = 0;

  //Variable to store available slots
  int availableSlots = 0;

  //Number of selected slots
  int selectedSlots = 0;

  bool isLoading = true;

  //Load method
  Future<void> load() async {

    //Loading weeks
    weeks = await weekRepository.loadWeekRecords();
    print("Loaded ${weeks.length} weeks");

    //Determining the number of total slots
    totalSlots = calculateTotalSlots();
    print("Total slots: $totalSlots");

    //Determining the number of available slots
    availableSlots = calculateAvailableSlots();
    print("Available slots: $availableSlots");

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  //Method to calculate the total number of total slots
  int calculateTotalSlots() {

    print("calculateTotalSlots called");
    print("weeks length: ${weeks.length}");

    int totalSlotsOfWeek = 0;

    //Looping through weeks
    for(Week week in weeks) {
      totalSlotsOfWeek = week.totalSlots;
      totalSlots += totalSlotsOfWeek;

      print("totalSlotsOfWeek: $totalSlotsOfWeek");
      print("totalSlots: $totalSlots");
    }
    return totalSlots;
  }

  //Method to calculate the total number of available slots
  int calculateAvailableSlots() {
    int availableSlotsOfWeek = 0;

    //Looping through weeks
    for(Week week in weeks) {
      availableSlotsOfWeek = week.availableSlots!;
      availableSlots += availableSlotsOfWeek;

      print("availableSlotsOfWeek: $availableSlotsOfWeek");
      print("availableSlots: $availableSlots");
    }
    return availableSlots;
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

    //Number of selected slots
    selectedSlots = totalSlots - availableSlots;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Selections Statistics",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(
          top: 100,
          left: 80,
          bottom: 100,
          right: 80,
        ),

          child: Column(
            children: [

              Container(
                width: 600,
                padding: const EdgeInsets.only(
                  right: 8,
                  left: 25,
                  top: 10,
                  bottom: 10,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blueGrey),
              ),
            
                child: Text("$selectedSlots / $totalSlots slots selected",
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              )
            ],
          )
      )
    );
  }
}
