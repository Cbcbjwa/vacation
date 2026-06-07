/*
*Ella Muro
*6 June 2026
*Selection Control UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/round.dart';
import 'week.dart';
import 'weekRepository.dart';
import 'user.dart';
import 'userRepository.dart';
import 'selection.dart';
import 'selectionService.dart';
import 'roundService.dart';
import 'round.dart';
import 'selectionService.dart';
import 'siteConstraintsChecker.dart';

class SelectionControlScreen extends StatefulWidget {
  const SelectionControlScreen({super.key});

  @override
  State<SelectionControlScreen> createState() => _SelectionControlScreenState();
}

class _SelectionControlScreenState extends State<SelectionControlScreen> {

  //Instantiating WeekRepository into an object
  WeekRepository weekRepository = WeekRepository();

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating RoundService into an object
  RoundService roundService = RoundService();

  //Instantiating SelectionService into an object
  SelectionService selectionService = SelectionService();

  //Instantiating SiteContraintsChecker into an object
  SiteConstraintsChecker siteConstraintsChecker = SiteConstraintsChecker();

  //List of weeks
  List<Week> weeks = [];

  //List of users
  List<User> users = [];

  //List of rounds
  List<Round> rounds = [];

  //User object
  User? selectedUser;

  //Week ID
  int? selectedWeekId;

  //Selection object
  Selection? currentWeekSelection; 

  //Week IDS of weeks already selected by the user
  List<int> lockedWeekIds = [];

  //Round object
  Round? selectedRound;

  //Method to load weeks/users
  Future<void> load() async {

    //Loading weeks
    final loadedWeeks = await weekRepository.loadWeekRecords();

    //Loading users
    final loadedUsers = await userRepository.loadRecords();

    //Loading rounds
    final loadedRounds = await roundService.getRounds();

    List<Selection> loadedSelections = [];

    //Loading user week selections
    if(selectedUser != null) {
      loadedSelections = await selectionService.getSelectionsByUser(selectedUser!.id);
    }

    Selection? selection;

    //Loading week selection
    if(selectedUser != null && selectedRound != null) {
      selection = await selectionService.getSelection(userId: selectedUser!.id, roundNumber: selectedRound!.roundNumber);
    }
    

    setState(() {
      weeks = loadedWeeks;
      users = loadedUsers;
      rounds = loadedRounds;

      currentWeekSelection = selection;

      //Flag to represent whether a user has made a selection for a round
      bool hasMadeSelection = currentWeekSelection != null;

      lockedWeekIds = loadedSelections.map((s) => s.weekId).toList();

      if(selection != null) {
        selectedWeekId = selection.weekId;
      } else {
        selectedWeekId = null;
      }

    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  //Method for getting the intial week
  Week? getInitialWeek() {
    if(selectedWeekId == null) {
      return null;
    }

    for (final w in weeks) {
      if (w.weekId == selectedWeekId) {
        return w;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {

    final filteredWeeks = weeks.where((week) {
            return week.availableSlots! > 0 || lockedWeekIds.contains(week.weekId);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Selection Control",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      body: Padding(
        padding: EdgeInsets.only(
          top: 35,
          bottom: 12,
          left: 95,
          right: 10,
        ),

        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 230,

                  //Dropdown menu for selecting a user
                  child: DropdownMenu<User>(
                    width: 230,
                    initialSelection: null,
                    hintText: "Select a user...",
                  

                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 195, 194, 194),
                      fontWeight: FontWeight.bold,
                    ),

                    //Dropdown menu item colors
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 38, 38, 38)),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
                    ),


                    dropdownMenuEntries: users.map((user) {

                      return DropdownMenuEntry<User>(
                        value: user,
                        label: user.userName,
                        labelWidget: Text(
                          user.userName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),

                    onSelected: (User? user) async {
                      setState(() {
                        selectedUser = user;
                      });
                      
                      //Refreshing
                      await load();
                    },
                  ),
                )
              ],
            ),

            //Spacing
            SizedBox(height: 35),

            Row(
              children: [
                SizedBox(
                  width: 230,

                  //Dropdown menu for selecting a round
                  child: DropdownMenu<Round>(
                    width: 230,
                    initialSelection: null,
                    hintText: "Select a round...",

                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 195, 194, 194),
                      fontWeight: FontWeight.bold,
                    ),

                    //Dropdown menu item colors
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 59, 59, 59)),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
                    ),

                    dropdownMenuEntries: rounds.map((round) {

                      return DropdownMenuEntry<Round>(
                        value: round,
                        label: round.roundName,
                        labelWidget: Text(
                          round.roundName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),

                    onSelected: (Round? round) async {
                      setState(() {
                        selectedRound = round;
                      });

                      //Refreshing
                      await load();
                    },
                  ),
                )
              ],
            ),

            //Spacing
            SizedBox(height: 35),

            Row(
              children: [
                SizedBox(
                  width: 230,

                  //Dropdown menu for selecting a week
                  child: DropdownMenu<Week>(
                    width: 230,
                    initialSelection: getInitialWeek(),
                    hintText: "Select a week...",
                  

                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 195, 194, 194),
                      fontWeight: FontWeight.bold,
                    ),

                    //Dropdown menu item colors
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 59, 59, 59)),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
                    ),


                    dropdownMenuEntries: filteredWeeks.map((week) {

                      final isLocked = lockedWeekIds.contains(week.weekId);

                      return DropdownMenuEntry<Week>(
                        value: week,
                        label: "Week ${week.weekNumber}: ${week.weekDate}",
                        labelWidget: Text(
                          isLocked 
                          ? "Week ${week.weekNumber}: (Already selected)"
                          : "Week ${week.weekNumber}: ${week.weekDate}",
                          style: TextStyle(
                            color: isLocked ? Colors.grey : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        enabled: !isLocked,

                        style: MenuItemButton.styleFrom(
                          backgroundColor: isLocked
                              ? const Color.fromARGB(255, 35, 35, 35)
                              : null,
                        ),

                      );
                    }).toList(),

                    onSelected: (Week? week) async {
                      setState(() {
                        selectedWeekId = week?.weekId;
                      });

                      //Refreshing
                      await load();
                    },
                  ),
                ),
              ],
            ),

            //Spacing
            SizedBox(height: 30),

            Row(
              children: [

                //Confirm button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                  disabledBackgroundColor: Colors.grey.shade800,
                  disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: currentWeekSelection != null
                  ? null
                  : () async {

                    if(selectedWeekId == null) {
                      return;
                    }

                    final reason = await siteConstraintsChecker.canSelectWeek(selectedWeekId!, selectedUser!.label!);

                    if(reason != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(reason)),
                      );
                      return;
                    }

                    try {

                      final created = await selectionService.createSelection(userId: selectedUser!.id, weekId: selectedWeekId!, roundNumber: selectedRound!.roundNumber);
                    
                      setState(() {
                        currentWeekSelection = created; 
                      });

                      await load();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Selection Confirmed")),
                      );

                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Confirmation Failed")),
                      );
                    }
                  },
                  child: Text("Confirm"),
                ),

                //Spacing
                SizedBox(width: 10),

                //Update button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                    disabledBackgroundColor: Colors.grey.shade800,
                    disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: (currentWeekSelection == null || selectedWeekId == null)
                  ? null
                  : () async {

                    if(selectedWeekId == null || currentWeekSelection == null) {
                      return;
                    }

                    print("selectedWeekId = $selectedWeekId");
                    print("currentWeekSelection = $currentWeekSelection");
                    print("UPDATE selectedUser.label = ${selectedUser!.label}");

                    final reason = await siteConstraintsChecker.canSelectWeek(selectedWeekId!, selectedUser!.label!, selectionIdToIgnore: currentWeekSelection!.selectionId);

                    if(reason != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(reason)),
                      );
                      return;
                    }

                    final success = await selectionService.updateSelection(selectionId: currentWeekSelection!.selectionId, weekId: selectedWeekId!);

                    if(success) {
                      setState(() {
                        currentWeekSelection!.weekId = selectedWeekId!;
                      });

                      await load();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Selection Updated")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Update Failed")),
                      );
                    }
                  },
                  child: Text("Update"),
                ),
              ]
            ),
          ],
        )
      )
    );
  }
}