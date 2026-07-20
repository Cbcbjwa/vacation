//Imports section
import 'package:flutter/material.dart';
import 'authService.dart';
import 'session.dart';
import 'role.dart';
import 'userScreen.dart';
import 'adminScreen.dart';
import 'loginScreen.dart';
import 'connectivityService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  //Instantiating AuthService into an object
  AuthService authService = AuthService();

  final connectivityService = ConnectivityService.instance;

  //Method to check if the user needs to login
  Future<void> checkLogin() async {

    if(!await connectivityService.checkConnection()) {

      print("No connection. Waiting to retry...");

      await Future.delayed(
        const Duration(seconds: 5),
      );

      if(mounted) {
        return checkLogin();
      }

      return;
    }

    try {

      final user = await authService.refresh();

      if (!mounted) return;

      if(user != null) {

        Session.load(user);

        print("Loaded Session:");
        print(Session.userId);
        print(Session.userName);
        print(Session.email);

        if(user.docRole == Role.admin) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserScreen()));
        }

      } else {

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const LoginScreen(title: "Login"),
              ),
          );
      }

    } catch (error) {
      print("SPLASH ERROR: $error");

      await Future.delayed(
        const Duration(seconds: 5),
      );

      if(mounted) {
        checkLogin();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Color(0xFFe8ffee),
  
        body: Center(
          child: 
            Image(
              image: AssetImage("vacationlotteryicon.png"),
              width: 150,
              height: 150,
            ),
        )
      );
  }
}