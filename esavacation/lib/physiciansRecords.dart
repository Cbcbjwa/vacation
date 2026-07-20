/*
*Ella Muro
*28 April 2026
*Physician Records UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/userRepository.dart';
import 'userService.dart';
import 'addUsersScreen.dart';
import 'userCard.dart';
import 'user.dart';
import 'package:collection/collection.dart';
import 'siteService.dart';
import 'site.dart';

class PhysiciansRecords extends StatefulWidget {
  const PhysiciansRecords({super.key});

   @override
  State<PhysiciansRecords> createState() => _PhysiciansRecordsState();
}

class _PhysiciansRecordsState extends State<PhysiciansRecords> {

  //Instantiating the UserService class into an object
  final UserService userService = UserService();

  //Instantiating UserRepository class into an object
  final UserRepository userRepository = UserRepository();

  //Instantiating SiteService into an object
  SiteService siteService = SiteService();

  //List to hold the searched user(s)
  List<User> searchedUsers = [];

  //Boolean flag to represent whether the user is editing a record
  bool isEditing = false;

  //Boolean flag to represent whether the searched for physician has been found
  bool searchedRecordFound = false;

  //Controller for the search query for the search dialog
  final searchController = TextEditingController();

  //Variable to show a search error if a searched for physician wasn't found
  String searchError = "";

  //Boolean flag to represent whether the user is actively searching for a record
  bool isSearching = false;

  //Variable to hold the search query
  String searchQuery = "";

  //List of sites
  List<Site> sites = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  //Method to load users and sites
  Future<void> load() async {
    await userRepository.loadRecords();
    sites = await siteService.getSites();
    setState(() {
      isLoading = false;
    });
  }

  //Method to search for users
  bool search(void Function(void Function()) setDialogState) {

    //Clearing searched users list
    searchedUsers = [];

    //Getting the search query for the search dialog
    searchQuery = searchController.text;

    //Preventing the user from searching for nothing
    if(searchQuery.isEmpty) {
      searchedUsers = [];
      searchError = "";
      setState(() {});
      setDialogState(() {});
      return false;
    }
      
    final results = userRepository.users.where((user) {
      return user.userName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final found = results.isNotEmpty;
  
    setDialogState(() {

    if(results.isEmpty) {
      searchError = "Physician Not Found";
    } else {
      searchError = "";
    }
    });

    if(found) {
      searchedUsers = results;
      searchError = "";
    } else {
      searchedUsers = [];
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
                    cursorColor: Color.fromARGB(255, 40, 89, 113),
                    decoration: InputDecoration(
                      hintText: "Enter Physician Name..",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 40, 89, 113), // underline color when typing
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              actions: [

                // Search button
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
        title: Text("Physicians",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 23,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddUsersScreen(
                onAdd: () async {
                  await userRepository.loadRecords();
                  setState(() {});
                },
              )
              ));
            },
          ),
        ],
      ),

      
    body: Builder(
      builder: (context) {

        var list = [];
        if(searchedUsers.isEmpty) {
          list = userRepository.users;
        } else {
          list = searchedUsers;
        }

        return ListView.builder(
          itemCount: list.length,

          itemBuilder: (context, index) {
            final user = list[index];

            return UserCard(
              key: ValueKey(user.id),
              user: user,
              sites: sites,

              onDelete: () async {
                await userRepository.loadRecords();
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