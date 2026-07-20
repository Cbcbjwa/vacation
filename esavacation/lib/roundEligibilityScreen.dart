/*
*Ella Muro
*1 June 2026
*Round Eligibility UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'selectionService.dart';
import 'session.dart';
import 'selection.dart';
import 'week.dart';
import 'weekRepository.dart';
import 'userRepository.dart';

class RoundEligibilityScreen extends StatefulWidget {
  const RoundEligibilityScreen({super.key});

  @override
  State<RoundEligibilityScreen> createState() => _RoundEligibilityScreenState();
}

class _RoundEligibilityScreenState extends State<RoundEligibilityScreen> {

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Number of rounds
  int numberOfRounds = 9;

  bool isLoading = true;

  //Method for building the round eligibility summary
  String buildSummary() {
    final buffer = StringBuffer();

    //Prepicks eligibility logic
    for(int prepick = 1; prepick <= 2; prepick++) {
      buffer.writeln("Prepicks $prepick:    ${Session.prepicksAllowed! >= prepick ? "Eligible" : "Ineligible"}");
      buffer.writeln();
    }

    //Regular round logic
    for(int round = 1; round <= numberOfRounds; round++) {
      buffer.writeln(
        "Round $round:    ${round <= Session.weeksAllowed! ? "Eligible" : "Ineligible"}",
      );

      if (round < 9) {
        buffer.writeln();
      }
    }

    return buffer.toString().trimRight();
  }

  //Method to load weeks/prepicks allowed for the current user
  Future<void> loadEligibility() async {
    final users = await userRepository.loadRecords();

    final currentUser = users.firstWhere((user) => user.id == Session.userId);

    setState(() {
      Session.weeksAllowed = currentUser.weeksAllowed;
      Session.prepicksAllowed = currentUser.prepicksAllowed;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadEligibility();
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
        title: Text("Round Eligibility",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 50),

          child: Container(
            padding: EdgeInsets.all(20),

            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueGrey,
                width: 2
              ),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Text(
              buildSummary(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ),
      ),
    );
  }
}