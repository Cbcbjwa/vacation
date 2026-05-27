/*
*Ella Muro
*22 April 2026
*Login Page UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/loginController.dart';
import 'authService.dart';
import 'logger.dart';
import 'role.dart';
import 'adminScreen.dart';
import 'userScreen.dart';
import 'session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //Controllers for getting the values of the email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Instantiating the login controller class into an object
  final LoginController loginController = LoginController(AuthService());

  //Instantiating the logger class into an object
  final AppLogger appLogger = AppLogger();
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.title, 
          style: TextStyle(
            color: Colors.grey,
            fontSize: 30,
            fontWeight: FontWeight.bold),
            ),
      ),
    
      body: Container(
        color: Colors.black,
        
        child: Padding (
          padding: const EdgeInsets.only(
            top: 250,
            left: 20,
            right: 20,
          ),
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            
            children: [

              //Email text field
              TextField(
                controller: emailController,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  hintText: "Enter Email...",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 75, 75, 75),
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              //Spacing the text fields
              SizedBox(height: 40),

              //Password text field
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  hintText: "Enter Password...",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 75, 75, 75),
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              //Spacing the password field and login button
              SizedBox(height: 20),

              //Login button
              ElevatedButton(
                onPressed: () async {

                  print("BUTTON PRESSED");

                  //Getting the login information entered by the user
                  final email = emailController.text;
                  final password = passwordController.text;

                  final user = await loginController.login(email, password);

                  if(user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid email or password")),
                    );
                    return;
                  }

                  Session.userId = user.id;
                  Session.userName = user.userName;
                  Session.displayName = user.displayName;

                  if(user.getDocRole() == Role.admin) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen()));
                  }
                 
                },
                child: Text("Login"),
              ),
            ],
          )
      ),
      ),
    );
  }
}
