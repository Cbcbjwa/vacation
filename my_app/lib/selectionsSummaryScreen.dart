/*
*Ella Muro
*7 May 2026
*Selections Summary UI
*/

//Imports section
import 'package:flutter/material.dart';

class SelectionsSummaryScreen extends StatefulWidget {
  const SelectionsSummaryScreen({super.key});

  @override
  State<SelectionsSummaryScreen> createState() => _SelectionsSummaryScreenState();

}

class _SelectionsSummaryScreenState extends State<SelectionsSummaryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Selections Summary",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }
}