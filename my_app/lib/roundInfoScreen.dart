/*
*Ella Muro
*12 June 2026
*Round Info UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'systemState.dart';
import 'systemStateService.dart';
import 'user.dart';
import 'userRepository.dart';
import 'session.dart';
import 'round.dart';
import 'roundService.dart';

class RoundInfoScreen extends StatefulWidget {
  const RoundInfoScreen({super.key});

  @override
  State<RoundInfoScreen> createState() => _RoundInfoScreenState();
}

class _RoundInfoScreenState extends State<RoundInfoScreen> {

  //Instantiating SystemStateService into an object
  SystemStateService systemStateService = SystemStateService();

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating RoundService into an object
  RoundService roundService = RoundService();

  //List of rounds
  List<Round> rounds = [];

  //System state
  SystemState? systemState;

  //Current user
  User? currentUser;

  //Flag to represent screen loading state
  bool isLoading = true;

  //Current round
  Round? currentRound;

  //Current round name
  String? roundName;

  //Total # of weeks allowed
  int totalNumOfWeeks = 0;

  //Load method
  Future<void> load() async {
  
    //Loading system state
    final loadedSystemState = await systemStateService.getSystemState();

    //Loading users
    final users = await userRepository.loadRecords();

    //Loading rounds
    final loadedRounds = await roundService.getRounds();
    
    currentUser = users.firstWhere((u) => u.id == Session.userId, orElse: () => users.first);

    setState(() {
      systemState = loadedSystemState;
      rounds = loadedRounds;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
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

    //Determining the name of the current round
    for(Round round in rounds) {
      if(round.roundNumber == systemState!.currentRoundNumber) {
        currentRound = round;
        break;
      }
    }
    roundName = currentRound?.roundName ?? "";

    //Determing the total number of weeks the user gets
    totalNumOfWeeks = currentUser!.prepicksAllowed + currentUser!.weeksAllowed;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Lottery Info",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      body: Padding(
        padding: EdgeInsets.only(
          top: 70,
          left: 30,
        ),
        child: Container(
        alignment: Alignment.center,
        height: 300,
        width: 360,
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          bottom: 20,
        ),

        
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueGrey,
            width: 2
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(

          
          children: [

            //Round number
            Row(
              children: [
                systemState!.currentRoundNumber < 100
                ? Text("Current Round: $roundName",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                )
                : Text("No Active Round",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                )
              ],
            ),

            SizedBox(height: 30),

            //Turn priority
            Row(
              children: [
                systemState!.currentRoundNumber < 100
                ? Text("Current Turn Priority: ${systemState!.currentTurnPriority}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                )
                : Text("Current Turn Priority: N/A",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                )
              ],
            ),

            SizedBox(height: 30),

            //User's prepicks turn priority
            Row(
              children: [
                currentUser!.prepicksPriorityNumber! > 0
                ? Text("Your Prepick Priority #: ${currentUser!.prepicksPriorityNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                )
                : Text("Your Prepick Priority #: N/A",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                )
              ],
            ),

            SizedBox(height: 30),

            //User's normal round turn priority
            Row(
              children: [
                Text("Your Main Lottery Priority #: ${currentUser!.priorityNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                ),
              ],
            ),

            SizedBox(height: 30),

            //User's number of weeks allowed
            Row(
              children: [
                Text("Total # of Weeks Allowed: $totalNumOfWeeks",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
                ),
              ],
            )
          ],
        ),
      ),
      )
    );
  }
}