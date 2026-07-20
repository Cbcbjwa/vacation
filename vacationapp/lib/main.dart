/*
*Ella Muro
*21 April 2026
*Main Application Class for Vacation Week Scheduling App
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/splashScreen.dart';
import 'connectivityService.dart';
import 'noInternetScreen.dart';
import 'dart:async';
import 'appWrapper.dart';

void main() {

  //Launching the app
  runApp(const VacationApp());
}

class VacationApp extends StatefulWidget {
  const VacationApp({super.key});

  @override
  State<VacationApp> createState() => _VacationAppState();

}

class _VacationAppState extends State<VacationApp> {

  final ConnectivityService connectivityService = ConnectivityService();

  bool isOnline = true;

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    checkConnection();

    subscription = connectivityService.stream.listen((_) {
    checkConnection();
    });
  }

  Future<void> checkConnection() async {

    bool online = await connectivityService.isOnline();

    if (!mounted) return;

    setState(() {
      isOnline = online;
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
      home: const AppWrapper()
    );
  }
}

