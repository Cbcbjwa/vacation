/*
*Ella Muro
*28 May 2026
*Round Eight Week Selection UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'weekRepository.dart';
import 'week.dart';
import 'selection.dart';
import 'selectionService.dart';
import 'session.dart';
import 'siteConstraintsChecker.dart';
import 'systemState.dart';
import 'roundControlService.dart';
import 'systemStateService.dart';

class Round8Screen extends StatefulWidget {
  const Round8Screen({super.key});

  @override
  State<Round8Screen> createState() => _Round8ScreenState();
}

class _Round8ScreenState extends State<Round8Screen> {

  //Instantiating WeekRepository class into an object
  WeekRepository weekRepository = WeekRepository();

  //Instantiating SelectionService class into an object
  SelectionService selectionService = SelectionService();

  //Instantiating SiteConstraintsChecker into an object
  SiteConstraintsChecker siteConstraintsChecker = SiteConstraintsChecker();

  //Instantiating RoundControlService into an object
  RoundControlService roundControlService = RoundControlService();

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //System state
  SystemState? systemState;

  //Variable to hold the selected week ID
  int? selectedWeekId;

  //List of weeks
  List<Week> weeks = [];

  //Selection object
  Selection? currentWeekSelection; 

  //Week IDS of weeks already selected by the user
  List<int> lockedWeekIds = [];

  //List of filtered weeks
  List<Week> filteredWeeks = [];

  bool isLoading = true;

  //Method to load weeks
  Future<void> load() async {

    print("ROUND 8 LOAD START");

    final data = await weekRepository.loadWeekRecords();
    final selection = await selectionService.getSelection(userId: Session.userId!, roundNumber: 8);
    final weekSelections = await selectionService.getSelectionsByUser(Session.userId!);

    systemState = await systemStateService.getSystemState();

    if (!mounted) return;

    setState(() {
      weeks = data;
      currentWeekSelection = selection;

      lockedWeekIds = weekSelections.map((s) => s.weekId).toList();

      if (selection != null) {
        selectedWeekId = selection.weekId;
      } else {
        selectedWeekId = null;
      }

      isLoading = false;
    });

    print("STATE UPDATED: ${weeks.length}");
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

    final filteredWeeks = weeks.where((week) {
            return week.availableSlots! > 0 || lockedWeekIds.contains(week.weekId);
          }).toList();

    print("WEEKS LENGTH ROUND 8 SEL SCN: ${weeks.length}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Round 8 Week Selection",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
          right: 20,
          left: 20,
          bottom: 20
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            Center(
              child: SizedBox(
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
                        color: Colors.white,
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

                onSelected: (Week? week) {
                  setState(() {
                    selectedWeekId = week?.weekId;
                  });
                },
              ),
              ),
            ),
    
            //Spacing
            SizedBox(height: 20),

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

                final reason = await siteConstraintsChecker.canSelectWeek(selectedWeekId!, Session.siteName!);

                if(reason != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(reason)),
                  );
                  return;
                }

                try {

                  final created = await selectionService.createSelection(userId: Session.userId!, weekId: selectedWeekId!, roundNumber: 8);
                
                  setState(() {
                    currentWeekSelection = created; 
                  });

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selection Confirmed")),
                  );

                  await roundControlService.startTurn();

                  if (!mounted) return;

                  SystemState updatedState = await systemStateService.getSystemState();
                  print("UPDATED TURN PRIORITY ${updatedState.currentTurnPriority}");

                  await load();

                } catch (error) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Confirmation Failed")),
                  );
                  print("CONFIRM ERROR: $error");
                }
              },
              child: Text("Confirm"),
            ),

            //Spacing
            SizedBox(height: 10),

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

                //Checking if the user can select the week
                final reason = await siteConstraintsChecker.canSelectWeek(selectedWeekId!, Session.siteName!, selectionIdToIgnore: currentWeekSelection!.selectionId);

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

                  if (!mounted) return;

                  await load();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selection Updated")),
                  );
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Update Failed")),
                  );
                }
              },
              child: Text("Update"),
            ),

          ],
        )
      )

    );
  }
}

