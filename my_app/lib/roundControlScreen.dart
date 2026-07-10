/*
*Ella Muro
*4 June 2026
*Round Control UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'roundControlService.dart';
import 'systemState.dart';
import 'systemStateService.dart';
import 'roundService.dart';
import 'round.dart';
import 'dart:async';
import 'lotteryService.dart';
import 'week.dart';
import 'weekRepository.dart';
import 'weekService.dart';
import 'selectionService.dart';

class RoundControlScreen extends StatefulWidget {
  const RoundControlScreen({super.key});

  @override
  State<RoundControlScreen> createState() => _RoundControlScreenState();
}

class _RoundControlScreenState extends State<RoundControlScreen> {

  //Instantiating RoundControlService into an object
  RoundControlService roundControlService = RoundControlService();

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //Instantiating RoundService into an object
  RoundService roundService = RoundService();

  //Instantiating WeekRepository into an object
  WeekRepository weekRepository = WeekRepository();

  //Instantiating WeekService into an object
  WeekService weekService = WeekService();

  //Instantiating SelectionService into an object
  SelectionService selectionService = SelectionService();

  //Instantiating LotteryService into an object
  final lotteryService = LotteryService();

  //List of rounds
  List<Round> rounds = [];

  //System state
  SystemState? systemState;

  //Flag to represent loading state
  bool isLoading = true;

  //Flag to represent if there is an active round
  bool isActiveRound = false;

  //Current round
  Round? currentRound;

  //Current round name
  String? roundName;

  //Timer
  Timer? refreshTimer;

  //List of weeks
  List<Week> weeks = [];

  Future<void> load() async {

    print("LOAD CALLED");
    print("LOAD CALLED FROM:");
    print(StackTrace.current);

    final newState = await systemStateService.getSystemState();

    if(newState.currentRoundNumber == systemState?.currentRoundNumber && newState.currentTurnPriority == systemState?.currentTurnPriority) {
    return; 
    }

    final loadedRounds = await roundService.getRounds();

    if(!mounted) {
      return;
    }

    setState(() {
      systemState = newState;
      rounds = loadedRounds;
      isLoading = false;
    });
  }

  //Method to load weeks
  Future<void> loadWeeks() async {
    final loadedWeeks = await weekRepository.loadWeekRecords();

    setState(() {
      weeks = loadedWeeks;
    });
  }

  @override
  void initState() {
    super.initState();

    print("INIT STATE: $hashCode");

    load();

    refreshTimer = Timer.periodic(Duration(seconds: 10), (_) => load());
  }

  @override
  void dispose() {
    print("DISPOSE: $hashCode");
    refreshTimer?.cancel();
    super.dispose();
  }

  //Method to reset all available slots upon a lottery reset
  Future<void> resetAvailableSlots() async {

    //Loading weeks
    await loadWeeks();

    //Looping through weeks to reset their available slots
    for(Week week in weeks) {
      await weekService.updateAvailableSlots(weekId: week.weekId, availableSlots: week.totalSlots);
    }
  }

  //Method to delete all selections upon a lottery reset
  Future<void> deleteAllSelections() async {
    await selectionService.deleteAllSelections();
  }

  //Method to show a dialog box to confirm if the user wants to continue with reseting the lottery
  Future<void> confirmLotteryReset() async {
    final bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("End Lottery?"),
          contentTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          content: Text("Are you sure you want to end the lottery?"),
          actions: [

            //Cancel deletion button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),

            //Confirm deletion button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      }
    );

    //Cancelling record deletion
    if(confirmation != true){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lottery Termination Cancelled")),
      );
      return;
    }

    await resetLottery();
  }

  //Method to show a dialog box to confirm whether the admin wants to reset the lottery
  Future<void> resetLottery() async {
    final bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("END Lottery?"),
          contentTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          content: Text("Are you POSITIVE you want to end the lottery?"),
          actions: [

            //Cancel deletion button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),

            //Confirm deletion button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      }
    );

    //Cancelling record deletion
    if(confirmation != true){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lottery Termination Cancelled")),
      );
      return;
    }

    //Setting round state to inactive
    final success = await roundService.updateRound(roundNumber: systemState!.currentRoundNumber, isActive: false);

    //Setting round number to something invalid
    final success2 = await systemStateService.updateCurrentRoundNum(sysStateId: 1, currentRoundNumber: 100);

    //Resetting current turn priority to 1
    final success3 = await systemStateService.updateCurrentTurnPriorityNumber(sysStateId: 1, currentTurnPriority: 1);

    //Resetting completion state of the rounds
    for(int i = -1; i <= 9; i++) {
      await roundService.updateRoundActivity(roundNumber: i, isComplete: false);
    }

    //Ending timer
    await lotteryService.endTimer();

    //Refreshing
    await load();

    //Resetting the available slots of weeks
    await resetAvailableSlots();

    //Deleting all selections
    await deleteAllSelections();

    if(!mounted) {
      return;
    }

    if(success && success2 && success3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lottery Reset Successfully")),
      );

    } else {

      if(!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lottery Termination Failed")),
      );
    }
  }

  //Method to show a dialog box to confirm that the user wants to start a round
  Future<void> startARound(int roundNumber, roundIndex) async {
    final bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Start Round?"),
          contentTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          content: Text("Are you sure you want to start ${rounds[roundIndex].roundName}?"),
          actions: [

            //Cancel deletion button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),

            //Confirm deletion button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      }
    );

    //Cancelling record deletion
    if(confirmation != true){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Round Commencement Cancelled")),
      );
      return;
    }

    //Starting round
    await lotteryService.startRound(roundNumber: roundNumber);

    //Refreshing
    await load();
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

    for(Round round in rounds) {
      if(round.roundNumber == systemState!.currentRoundNumber) {
        currentRound = round;
        break;
      }
    }
    roundName = currentRound?.roundName ?? "";

    print("isActive: ${rounds[0].isActive}");
    print("isComplete: ${rounds[0].isComplete}");

    if(systemState!.currentRoundNumber < 100) {
      isActiveRound = true;
    } else {
      isActiveRound = false;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Round Control",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.only(
          top: 45,
          right: 20,
          left: 65,
        ),

        child: Column(
          children: [

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isActiveRound
                  ? Text("Active Round: $roundName\n\nCurrent Turn Priority: ${systemState!.currentTurnPriority}",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 40, 89, 113),
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        ),
                      )
                  : Text("No Active Round",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 40, 89, 113),
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ] ,
              ),
            ),

            //Spacing
            SizedBox(height: 55),


              Row(
                children: [
    
                  ElevatedButton.icon(
                    
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                        disabledBackgroundColor: Colors.grey.shade800,
                        disabledForegroundColor: Colors.white60,
                    ),
                    onPressed: rounds[0].isActive || rounds[0].isComplete
                    ? null
                    : () async {

                      //Starting round
                      await startARound(-1, 0);
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text("Prepicks 1",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  //Spacing
                  SizedBox(width: 25),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                        disabledBackgroundColor: Colors.grey.shade800,
                        disabledForegroundColor: Colors.white60,
                    ),
                    onPressed: rounds[1].isActive || rounds[1].isComplete
                    ? null
                    : () async {

                      //Starting round
                      await startARound(0, 1);
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text("Prepicks 2",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              //Spacing
              SizedBox(height: 40),

              Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[2].isActive || rounds[2].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(1, 2);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 1",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                //Spacing
                SizedBox(width: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[3].isActive || rounds[3].isComplete
                  ? null 
                  : () async {
                    
                    //Starting round
                    await startARound(2, 3);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 2",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //Spacing
            SizedBox(height: 40),

            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[4].isActive || rounds[4].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(3, 4);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 3",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                //Spacing
                SizedBox(width: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[5].isActive || rounds[5].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(4, 5);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 4",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //Spacing
            SizedBox(height: 40),

            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[6].isActive || rounds[6].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(5, 6);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 5",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                //Spacing
                SizedBox(width: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[7].isActive || rounds[7].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(6, 7);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 6",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //Spacing
            SizedBox(height: 40),

            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[8].isActive || rounds[8].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(7, 8);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 7",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                //Spacing
                SizedBox(width: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                  ),
                  onPressed: rounds[9].isActive || rounds[9].isComplete
                  ? null
                  : () async {
                    
                    //Starting round
                    await startARound(8, 9);
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Round 8",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //Spacing
            SizedBox(height: 40),

            Padding(
              padding: EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                      disabledBackgroundColor: Colors.grey.shade800,
                      disabledForegroundColor: Colors.white60,
                    ),
                    onPressed: rounds[10].isActive || rounds[10].isComplete
                    ? null
                    : () async {
                      
                      //Starting round
                      await startARound(9, 10);
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text("Round 9",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(
                top: 80,
                right: 40,
                bottom: 40,
              ),
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 123, 9, 1),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await confirmLotteryReset();
                    },
                    child: Text("Reset Lottery"),
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}