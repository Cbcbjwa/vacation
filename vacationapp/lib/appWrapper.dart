import 'dart:async';
import 'package:flutter/material.dart';
import 'connectivityService.dart';
import 'noInternetScreen.dart';
import 'splashScreen.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {

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

    final online = await connectivityService.isOnline();

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

    return Stack(
      children: [

        const SplashScreen(),

        if (!isOnline)
          NoInternetScreen(
            onRetry: checkConnection,
          ),
      ],
    );
  }
}