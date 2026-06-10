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

  //System state
  SystemState? systemState;

  //Flag to represent loading state
  bool isLoading = true;

  //Flag to represent if there is an active round
  bool isActiveRound = false;

  Future<void> load() async {
    final loadedSystemState = await systemStateService.getSystemState();

    setState(() {
      isLoading = false;
      systemState = loadedSystemState;
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

      body: Padding(
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
                  ? Text("Active Round: Round ${systemState!.currentRoundNumber}",
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
                    ),
                    onPressed: () async {
                      await roundControlService.startRound(-1);
                      
                      //Refreshing
                      await load();
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
                    ),
                    onPressed: () {
                      
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                  ),
                  onPressed: () {
                    
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
                    ),
                    onPressed: () {
                      
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
                      await systemStateService.updateCurrentRoundNum(sysStateId: 1, currentRoundNumber: 100);
                      await load();
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