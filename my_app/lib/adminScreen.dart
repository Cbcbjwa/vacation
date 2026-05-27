/*
*Ella Muro
*26 April 2026
*Admin Screeen UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/prepicksOneScreen.dart';
import 'package:my_app/selectionsSummaryScreen.dart';
import 'physiciansRecords.dart';
import 'loginScreen.dart';
import 'weekRecords.dart';
import 'weekRepository.dart';
import 'week.dart';
import 'slotStatus.dart';
import 'siteRecords.dart';
import 'round1Screen.dart';
import 'round2Screen.dart';
import 'selection.dart';
import 'userRepository.dart';
import 'selectionService.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();

}

class _AdminScreenState extends State<AdminScreen> {

  //Instantiating WeekRepository class into an object
  WeekRepository weekRepository = WeekRepository();

  //Instantiating UserRepository class into an object
  UserRepository userRepository = UserRepository();

  //Instantiating SelectionService class into an object
  SelectionService selectionService = SelectionService();

  //List to hold the weeks
  List<Week> listOfWeeks = [];

  //List to hold all selections
  List<Selection> allSelections = [];

  Map<int, String> userNamesById = {};

  @override
  void initState() {
    super.initState();
    print("INITSTATE RAN");
    load();
  }

  //Method to load weeks
  Future<void> load() async {
    print("LOAD START");

    //Loading weeks
    final data = await weekRepository.loadWeekRecords();

    //Loading users
    final users = await userRepository.loadRecords();

    //Loading selections
    final selections = await selectionService.getSelections();


    print("DATA RECEIVED: ${data.length}");
    print("DATA: $data");

    print("HASH: ${weekRepository.hashCode}");
    print("AFTER LOAD: ${weekRepository.weeks.length}");

    setState(() {
      listOfWeeks = data;

      for (final user in users) {
        userNamesById[user.id] = user.displayName;
      }

      allSelections = selections;
    });
}

  @override
  Widget build(BuildContext context) {

    print("Weeks: ${weekRepository.weeks.length}");
    print("BUILD HASH: ${weekRepository.hashCode}");
    print("BUILD WEEKS: ${weekRepository.weeks.length}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Admin Dashboard",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      drawer: Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
          children: [

            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                "Admin Menu",
                style: TextStyle(color: Colors.grey, fontSize:25, fontWeight: FontWeight.bold),
              )
            ),

            //Physician Records Section
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.people, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Physicians",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => PhysiciansRecords()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Week Records Section
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.edit_calendar, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Weeks",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                 await Navigator.push(context, MaterialPageRoute(builder: (context) => WeeksRecords()));
                 load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Site Records Section
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.apartment, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Sites",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => SitesRecords()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round Controls
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.display_settings_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round Control",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Selections Summary
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.summarize_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Selections Summary",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionsSummaryScreen()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Selections Stats
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.bar_chart, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Selections Stats",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //All physician selections
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.text_snippet_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Physician Selections",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Prepicks Round 1 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.looks_one, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Prepicks 1",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => PrepicksRoundOneScreen()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Prepicks Round 2 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.looks_two, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Prepicks 2",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 1 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.beach_access, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 1",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => Round1Screen()));
                load();
              }
            ),


            //Spacing the menu items
            SizedBox(height: 2),

            //Round 2 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.sunny, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 2",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => Round2Screen()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 3 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.card_travel, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 3",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 4 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.local_airport, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 4",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 5 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.icecream, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 5",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 6 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.downhill_skiing_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 6",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 7 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.airplane_ticket, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 7",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 8 Selection
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.surfing, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round 8",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {

              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Logout Section
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.logout, fontWeight: FontWeight.bold, color: Colors.red),
              title: const Text("Logout",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(title: "Login")));
                load();
              },
            )
          ],
        ),
      ),

      //**SCHEDULE GRID**\\
      body: ListView.builder(

        itemCount: listOfWeeks.length,
        itemBuilder: (context, index) {

          final week = listOfWeeks[index];

          final weekSelections = allSelections.where((selection) => selection.weekId == week.weekId).toList();

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueGrey,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                //Frozen Section -- Week Number, Info, and Date

                SizedBox(
                  width: 220,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text("Week ${week.weekNumber}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ) ,
                          ),

                          //Spacing
                          SizedBox(height: 6),

                          Text(week.weekDate,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ) ,
                          ),

                          //Spacing
                          SizedBox(height: 6),

                          Text(week.specialSpecification == null || week.specialSpecification!.toLowerCase() == "n/a" ? "" : week.specialSpecification!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ]
                      ),
                    ),

                    //Frozen column for available slots
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${week.availableSlots}/${week.totalSlots} slots \n available",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                    ]
                  )
                ),


                //Horizontal Slot Scrolling Section
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                      child: Row(
                        children: [
                          ...List.generate(8, (slotIndex) {


                            //**Slot Display Logic**\\

                            //Variables
                            SlotStatus slotStatus = SlotStatus.available;
                            String slotText = "";

                            if(slotIndex >= week.totalSlots) {
                              slotStatus = SlotStatus.unavailable;
                            } else {

                              if(slotIndex < weekSelections.length) {
                                slotStatus = SlotStatus.picked;
                                
                                final selection = weekSelections[slotIndex];
                                slotText = userNamesById[selection.userId] ?? "";
                              }
                            }


                            //Slot color handler
                            Color slotColor;

                            switch(slotStatus) {

                              case SlotStatus.available: 
                                slotColor = Colors.green;
                                slotText = "";
                                break;

                              case SlotStatus.picked:
                                slotColor = Colors.yellow;
                                break;

                              case SlotStatus.unavailable:
                                slotColor = Colors.grey;
                                slotText = "N/A";
                                break;
                                }

                              return Container (
                                width: 120,
                                height: 70,

                                margin: EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),

                                decoration: BoxDecoration(
                                  color: slotColor,
                                  borderRadius: BorderRadius.circular(8),

                                  border: Border.all(
                                    color: Colors.white24,
                                  ),
                                  ),

                                alignment: Alignment.center,

                                  child: Text(
                                    slotText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        )
                      )
                    
              ]
            )
          );
                  
              
        }
      )
    );
  }
}