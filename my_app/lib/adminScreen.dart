/*
*Ella Muro
*26 April 2026
*Admin Screeen UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/accountScreen.dart';
import 'package:my_app/allSelectionsScreen.dart';
import 'package:my_app/prepicksOneScreen.dart';
import 'package:my_app/round9Screen.dart';
import 'package:my_app/roundControlScreen.dart';
import 'package:my_app/roundEligibilityScreen.dart';
import 'package:my_app/selectionControlScreen.dart';
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
import 'round3Screen.dart';
import 'selectionStatsScreen.dart';
import 'round4Screen.dart';
import 'round5Screen.dart';
import 'round6Screen.dart';
import 'round7Screen.dart';
import 'round8Screen.dart';
import 'prepicks2Screen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'roundEligibilityService.dart';
import 'session.dart';
import 'systemState.dart';
import 'systemStateService.dart';
import 'user.dart';

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

  //Instantiating RoundEligibilityService into an object
  RoundEligibilityService roundEligibilityService = RoundEligibilityService();

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //List to hold the weeks
  List<Week> listOfWeeks = [];

  //List to hold all selections
  List<Selection> allSelections = [];

  Map<int, String> userNamesById = {};

  //Flag to represent if a week is full
  bool isFull = false;

  //Flag to represent if a week is getting low (4 or less slots available)
  bool isGettingLow = false;

  //Flag to represent whether the list of weeks is in list view or grid view
  bool isInGridView = false;

  List<bool> roundEligibility = List.filled(9, false);
  List<bool> prepickEligibility = List.filled(2, false);

  //System state
  SystemState? systemState;

  //Flag to represent screen loading state
  bool isLoading = true;

  //Flag to represent whether it is the user's turn to select a week
  bool isUsersTurn = false;

  //Flag to represent whether a round is active or complete
  bool isActiveOrComplete = false;

  //Current user
  User? currentUser;

  //Method to load weeks/users/selections
  Future<void> load() async {

    print("LOAD START");

    //Loading weeks
    final data = await weekRepository.loadWeekRecords();
    print("Weeks loaded");

    //Loading users
    final users = await userRepository.loadRecords();
    print("Users loaded");

    //Loading selections
    final selections = await selectionService.getSelections();
    print("Selections loaded");

    currentUser = users.firstWhere((u) => u.id == Session.userId, orElse: () => users.first);

    systemState = await systemStateService.getSystemState();

    setState(() {
      listOfWeeks = data;
      allSelections = selections;

      for (final user in users) {
        userNamesById[user.id] = user.displayName;
      }

      roundEligibility = roundEligibilityService.computeRoundEligibility(currentUser!.weeksAllowed);

      prepickEligibility = roundEligibilityService.computePrepickEligibility(currentUser!.prepicksAllowed);
    });

    print("weeksAllowed: ${currentUser!.weeksAllowed}");
    print("prepicksAllowed: ${currentUser!.prepicksAllowed}");

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    print("INITSTATE RAN");
    load();
  }

  //Method for building the list view version of the weeks display
  Widget buildListView() {

    return Padding(
        padding: EdgeInsets.only(
          top: 25,
        ),
        
        child: ListView.builder(

        itemCount: listOfWeeks.length,
        itemBuilder: (context, index) {

          final week = listOfWeeks[index];

          final weekSelections = allSelections.where((selection) => selection.weekId == week.weekId).toList();

          Color weekBackgroundColor = week.availableSlots == 0 ? const Color.fromARGB(255, 224, 17, 2) : Colors.blueGrey;

          Color availableSlotsTextColor = (week.availableSlots! > 0 && week.availableSlots! <= 4) ? const Color.fromARGB(255, 175, 68, 1) : Colors.black;

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5.5,
            ),

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: weekBackgroundColor,
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
                              color: availableSlotsTextColor,
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

  //Method to build the grid view version of the weeks display
  Widget buildGridView() {
    return Padding(
        padding: EdgeInsets.only(top: 25),
        
        child: Container(
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
                label: Center( 
                  child: Text(
                    "Week",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const DataColumn2(
                fixedWidth: 130,
                label: Center(
                  child: Text(
                    "Date",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              ...List.generate(8, (index) {

                final slots = index + 1;

                return DataColumn2(
                  fixedWidth: 100,

                  label: Center(
                    child: Text(
                      "Slot $slots",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                );
              }),
            ],

            rows: listOfWeeks.map((week) {

              final weekSelections = allSelections.where((selection) => selection.weekId == week.weekId).toList();

              //Helper method for building slots
              Widget buildSlotCell(int slotIndex) {

                if(slotIndex >= week.totalSlots) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    
                    alignment: Alignment.center,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "N/A",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if(slotIndex < weekSelections.length) {
                  final selection = weekSelections[slotIndex];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    
                    alignment: Alignment.center,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      userNamesById[selection.userId] ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                 return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                    
                    alignment: Alignment.center,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),

                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }

              return DataRow2(
                cells: [
                  DataCell(
                    Center(
                      child: Text(
                        week.weekNumber.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    Center( 
                      child: Text(
                        textAlign: TextAlign.center,
                        week.weekDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  ...List.generate(8, (slotIndex) {

                    return DataCell(
                      buildSlotCell(slotIndex),
                    );
                  }),
                ],
              );
            }).toList(),
          ),
        ),
      );
  }

  //Method to determine if a round list tile can be accessed
  bool isRoundAccessible(int requiredRound) {
    return systemState!.currentRoundNumber >= requiredRound && systemState!.currentRoundNumber !=100;
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

    print("Weeks: ${weekRepository.weeks.length}");
    print("BUILD HASH: ${weekRepository.hashCode}");
    print("BUILD WEEKS: ${weekRepository.weeks.length}");

    if(systemState!.currentTurnPriority == currentUser!.priorityNumber || systemState!.currentTurnPriority == currentUser!.prepicksPriorityNumber) {
      isUsersTurn = true;
    }

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
        ),

        actions: [
          IconButton(
            icon: Icon(
              isInGridView ? Icons.view_list_sharp : Icons.grid_view,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isInGridView = !isInGridView;
              });
            },
          ),
        ],
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

            //Round Control
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.display_settings_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round Control",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => RoundControlScreen()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Selection Control
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.sports_esports_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Selection Control",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionControlScreen()));
                load();
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

            //Round eligibility
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.help_center, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Round Eligibility",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => RoundEligibilityScreen()));
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
                await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionStatsScreen()));
                load();
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
                 await Navigator.push(context, MaterialPageRoute(builder: (context) => AllSelectionsScreen()));
                load();
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Prepicks Round 1 Selection
            if(prepickEligibility[0]) 
              ListTile(
                enabled: isRoundAccessible(-1) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.looks_one, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Prepicks 1",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Prepicks1Screen()));
                  load();
                }
              ),
            
            //Spacing the menu items
            SizedBox(height: 2),

            //Prepicks Round 2 Selection
            if(prepickEligibility[1])
              ListTile(
                enabled: isRoundAccessible(0) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.looks_two, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Prepicks 2",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Prepicks2Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 1 Selection
            if(roundEligibility[0])
              ListTile(
                enabled: isRoundAccessible(1) && isUsersTurn,
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
            if(roundEligibility[1])
              ListTile(
                enabled: isRoundAccessible(2) && isUsersTurn,
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
            if(roundEligibility[2])
              ListTile(
                enabled: isRoundAccessible(3) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.card_travel, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 3",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round3Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 4 Selection
            if(roundEligibility[3])
              ListTile(
                enabled: isRoundAccessible(4) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.local_airport, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 4",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round4Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 5 Selection
            if(roundEligibility[4])
              ListTile(
                enabled: isRoundAccessible(5) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.icecream, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 5",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round5Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 6 Selection
            if(roundEligibility[5])
              ListTile(
                enabled: isRoundAccessible(6) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.downhill_skiing_outlined, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 6",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round6Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 7 Selection
            if(roundEligibility[6])
              ListTile(
                enabled: isRoundAccessible(7) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.airplane_ticket, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 7",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round7Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 8 Selection
            if(roundEligibility[7])
              ListTile(
                enabled: isRoundAccessible(8) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.surfing, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 8",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round8Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Round 9 Selection
            if(roundEligibility[8])
              ListTile(
                enabled: isRoundAccessible(9) && isUsersTurn,
                tileColor: Colors.black,
                leading: const Icon(Icons.rocket_launch, fontWeight: FontWeight.bold, color: Colors.grey),
                title: const Text("Round 9",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Round9Screen()));
                  load();
                }
              ),

            //Spacing the menu items
            SizedBox(height: 2),

            //Account section
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.info_outline_rounded, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Account",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
                load();
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
      body: isInGridView
        ? buildGridView()
        : buildListView()
    );
  }
}