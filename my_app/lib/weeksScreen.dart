/*
*Ella Muro
*28 April 2026
*Week Records UI
*/

//Imports section
import 'package:flutter/material.dart';

class WeeksScreen extends StatefulWidget {
  const WeeksScreen({super.key});

  @override
  State<WeeksScreen> createState() => _WeeksScreenState();
}

class _WeeksScreenState extends State<WeeksScreen> {

  @override
  Widget build(BuildContext context) {
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
        )
      ),
    );
  }
}
