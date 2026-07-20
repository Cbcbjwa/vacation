import 'dart:async';
import 'package:flutter/material.dart';
import 'connectivityService.dart';
import 'noInternetScreen.dart';
import 'splashScreen.dart';

class AppWrapper extends StatefulWidget {

  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {

  final connectivityService = ConnectivityService.instance;

  StreamSubscription? subscription;

  Timer? connectionTimer;

  VoidCallback? connectionListener;

  @override
  void initState() {
    super.initState();

    print("APP WRAPPER FIRED");

    //Listening for Wi-Fi/cellular changes
    subscription = connectivityService.stream.listen((_) {
      connectivityService.checkConnection();
    });

    //Listening for service failures from http calls
    connectionListener = () {
      print("Connectivity state changed!");

      if(mounted) {
        setState(() {});
      }
    };

    connectivityService.addListener(connectionListener!);

    //Initial connection check
    connectivityService.checkConnection();

    //Periodic connection check
    connectionTimer = Timer.periodic(const Duration(seconds: 10), 
      (_) { 
        print("TIMER FIRED");
        connectivityService.checkConnection();
      }
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    connectionTimer?.cancel();
    connectivityService.removeListener(connectionListener!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        widget.child,

        if(!connectivityService.isOnline)
          NoInternetScreen(
            onRetry: connectivityService.checkConnection,
          ),
      ],
    );
  }
}