/*
*Ella Muro
*21 April 2026
*Main Application Class for Vacation Week Scheduling App
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/splashScreen.dart';
import 'loginScreen.dart';

void main() {

  //Launching the app
  runApp(const VacationApp());
}

class VacationApp extends StatelessWidget {
  const VacationApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.blueGrey,
          selectionColor: Colors.blueGrey
        )
      ),
      title: 'Vacation Scheduler',
      home: const SplashScreen(),
    );
  }
}

