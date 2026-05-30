/*
*Ella Muro
*28 May 2026
*Selection Summary UI
*/

//Imports section
import 'package:flutter/material.dart';

class SelectionSummaryScreen extends StatefulWidget {
  const SelectionSummaryScreen({super.key});

  @override
  State<SelectionSummaryScreen> createState() => _SelectionSummaryScreenState();
}

class _SelectionSummaryScreenState extends State<SelectionSummaryScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Round 3 Week Selection",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }
}