/*
*Ella Muro
*28 May 2026
*Selection Statistics UI
*/

//Imports section
import 'package:flutter/material.dart';

class SelectionStatsScreen extends StatefulWidget {
  const SelectionStatsScreen({super.key});

  @override
  State<SelectionStatsScreen> createState() => _SelectionStatsScreenState();
}

class _SelectionStatsScreenState extends State<SelectionStatsScreen> {

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Selections Statistics",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
