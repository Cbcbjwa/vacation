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
import 'weeksScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();

}

class _AdminScreenState extends State<AdminScreen> {

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PhysiciansRecords()));
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
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => WeeksScreen()));
              }
            ),

            //Spacing the menu items
            SizedBox(height: 2),

             //Selections Summary
            ListTile(
              tileColor: Colors.black,
              leading: const Icon(Icons.summarize, fontWeight: FontWeight.bold, color: Colors.grey),
              title: const Text("Selections Summary",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionsSummaryScreen()));
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrepicksRoundOneScreen()));
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
              onTap: () {

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
              onTap: () {

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
              onTap: () {

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
              onTap: () {

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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(title: "Login")));
              }
            )
          ],
        ),
      ),

      

    );
  }
}