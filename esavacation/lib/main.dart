/*
*Ella Muro
*21 April 2026
*Main Application Class for Vacation Week Scheduling App
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/splashScreen.dart';
import 'dart:async';
import 'appWrapper.dart';

void main() {

  runZonedGuarded(() {

    //Launching the app
    runApp(const VacationApp());
  },
    (error, stackTrace) {
      print("GLOBAL ASYNC ERROR: $error");
    },
  );
}

class VacationApp extends StatefulWidget {
  const VacationApp({super.key});

  @override
  State<VacationApp> createState() => _VacationAppState();

}

class _VacationAppState extends State<VacationApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.blueGrey,
          selectionColor: Colors.blueGrey
        ),
      ),
      title: 'ESA Vacation',
      home: const SplashScreen(),

      builder: (context, child) {
        return AppWrapper(
          child: child!,
        );
      },
    );
  }
}

