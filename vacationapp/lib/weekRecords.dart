/*
*Ella Muro
*28 April 2026
*Week Records UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/weekService.dart';
import 'weekRepository.dart';
import 'week.dart';
import 'weekCard.dart';
import 'addWeeksScreen.dart';

class WeeksRecords extends StatefulWidget {
  const WeeksRecords({super.key});

  @override
  State<WeeksRecords> createState() => _WeeksRecordsState();
}

class _WeeksRecordsState extends State<WeeksRecords> {

  //Instantiating the WeekService class into an object
  final WeekService weekService = WeekService();

  //Instantiating the WeekRepository class into an object
  final WeekRepository weekRepository = WeekRepository();

  //Controller for the search query for the search dialog
  final searchController = TextEditingController();

  //List to hold searched weeks
  List<Week> searchedWeeks = [];

  //Variable to show a search error if a searched for week wasn't found
  String searchError = "";

  //Variable to hold the search query
  String searchQuery = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  //Method to load weeks
  Future<void> load() async {
    await weekRepository.loadWeekRecords();
    setState(() {
      isLoading = false;
    });
  }

  //Method to search for weeks
  bool search(void Function(void Function()) setDialogState) {

    //Clearing searched weeks list
    searchedWeeks = [];

    //Getting the search query for the search dialog
    searchQuery = searchController.text;

    //Preventing the user from searching for nothing
    if(searchQuery.isEmpty) {
      searchedWeeks = [];
      searchError = "";
      setState(() {});
      setDialogState(() {});
      return false;
    }

    //Search results
    List<Week> results = [];
    
    //Searching the master list of weeks for a match
    for(Week week in weekRepository.weeks) {
      if(week.weekNumber.toString() == searchQuery || week.weekDate == searchQuery || (week.specialSpecification ?? "").toLowerCase().trim() == searchQuery.toLowerCase().trim()) {
        results.add(week);
      }
    }

    final found  = results.isNotEmpty;

    setDialogState(() {

    if(results.isEmpty) {
      searchError = "Week Not Found";
    } else {
      searchError = "";
    }
    });

    if(found) {
      searchedWeeks = results;
      searchError = "";
    } else {
      searchedWeeks = [];
    }

    setState(() {});
    setDialogState(() {});
    return found;
  }

  //Method to show a dialog box for searching for records
  Future<void> showSearchDialog() async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(

          builder: (context, setDialogState) {

            return AlertDialog(

              title: Text("Search"),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(
                    searchError,
                    style: TextStyle(color: Colors.red),
                  ),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Week Number, Date, or Label..",
                    ),
                  ),
                ],
              ),

              actions: [

                //Search button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                  ),
                  onPressed: () {

                    final found = search(setDialogState);

                    if(found) {
                      Navigator.pop(context);
                    }

                  },

                  child: Text("Search"),
                ),

                // Cancel button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                  ),
                  onPressed: () {

                    Navigator.pop(context);

                  },

                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
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
        title: Text("Weeks",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          
          //Search button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            }
          ),                    

          //Add new record button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddWeeksScreen(
                onAdd: () async {
                  await weekRepository.loadWeekRecords();
                  setState(() {});
                },
              )
              ));
            }
          )
        ]
      ),

      body: Builder(
      builder: (context) {

        var list = searchedWeeks.isNotEmpty ? searchedWeeks : weekRepository.weeks;

        return ListView.builder(
          itemCount: list.length,

          itemBuilder: (context, index) {
            final week = list[index];

            return WeekCard(
              key: ValueKey(week.weekId),
              week: week,

              onDelete: () async {
                await weekRepository.loadWeekRecords();
                setState(() {});
              },
            );
          }
        );
      }
    )
    );
  }
}
