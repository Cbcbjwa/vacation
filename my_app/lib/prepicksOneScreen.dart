/*
*Ella Muro
*26 April 2026
*Prepicks Round 1 Week Selection screen
*/

//Imports section
import 'package:flutter/material.dart';

class PrepicksRoundOneScreen extends StatefulWidget {
  const PrepicksRoundOneScreen({super.key});

  @override
  State<PrepicksRoundOneScreen> createState() => _PrepicksRoundOneScreenState();

}

class _PrepicksRoundOneScreenState extends State<PrepicksRoundOneScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Prepicks Round 1",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),

      //Dropdown for selecting a week

      
    );
  }
}