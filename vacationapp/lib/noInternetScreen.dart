//Imports section
import 'package:flutter/material.dart';
import 'dart:async';

class NoInternetScreen extends StatefulWidget {

  //Field of the class
  final VoidCallback onRetry;

  //Constructor
  const NoInternetScreen({super.key, required this.onRetry});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();

}

class _NoInternetScreenState extends State<NoInternetScreen> {

  //Retry timer
  Timer? retryTimer;

  @override
  void initState() {
    super.initState();

    retryTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => widget.onRetry(),
    );
  }

  @override
  void dispose() {
    retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
  
      body: Center(
        child: 
          Padding(
            padding: const EdgeInsets.all(30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                //No wifi icon
                Icon(
                  Icons.wifi_off,
                  size: 90,
                  color: Colors.red,
                ),

                //Spacing
                SizedBox(height: 25),

                Text(
                  "No Internet Connection",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  "This application requires an internet connection to function.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: 35),

                //Retry button
                ElevatedButton(
                  onPressed: widget.onRetry,
                  child: Text("Retry"),
                ),
              ],
            ),
          ),
      )
    );
  }
}