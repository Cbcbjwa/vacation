//Imports section
import 'package:flutter/material.dart';
import 'authService.dart';
import 'session.dart';
import 'role.dart';
import 'userScreen.dart';
import 'adminScreen.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  //Instantiating AuthService into an object
  AuthService authService = AuthService();

  //Method to check if the user needs to login
  Future<void> checkLogin() async {

    final user = await authService.refresh();

    if (!mounted) return;

    if (user != null) {

        Session.load(user);

        if(user.docRole == Role.admin) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen()));
        }

    } else {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const LoginScreen(title: "Login"),
            ),
        );

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
            ),
        )
      );
  }
}