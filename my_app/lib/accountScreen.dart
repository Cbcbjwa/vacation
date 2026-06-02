/*
* Ella Muro
* 30 May 2026
* Account Info UI
*/

import 'package:flutter/material.dart';
import 'session.dart';
import 'userService.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  bool showPasswordFields = false;
  bool obscureNewPassword = true;

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  //Instantiating UserService class into an object
  UserService userService = UserService();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  //Method for changing a password
  void changePassword() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          //Spacing
          SizedBox(height: 150),

          //Section header
          Center(
            child: Text(
              "Personal Information",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),

          //Spacing
          SizedBox(height: 30),

          //User's name
          Center(
            child: Text(
              Session.userName!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),

          //Spacing
          SizedBox(height: 15),

          //User's email
          Center(
            child: Text(
              Session.email!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),

          //Spacing
          SizedBox(height: 100),

          //Section header
          Center(
            child: Text(
              "Security",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),

          //Spacing
          SizedBox(height: 30),

          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  showPasswordFields = !showPasswordFields;
                });
              },
              child: Text("Change Password"),
            ),
          ),

          if (showPasswordFields) ...[
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: currentPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Current Password",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: newPasswordController,
                obscureText: obscureNewPassword,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  //style: 
                  //ElevatedButton.styleFrom(
                   // foregroundColor: Colors.black,
                  //),
                  onPressed: () async {
                    String currentPassword = currentPasswordController.text;
                    String newPassword = newPasswordController.text;

                    print("Current Password: $currentPassword");
                    print("New Password: $newPassword");

                    String result = await userService.changePassword(userId: Session.userId!, currentPassword: currentPassword, newPassword: newPassword);
                  
                    if(result == "Success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password Changed")),
                      );

                      setState(() {
                        showPasswordFields = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)));
                    }
                  },
                  child: Text("Submit"),
                ),

                //Spacing
                SizedBox(width: 15),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPasswordFields = false;
                    });
                  },
                  child: Text("Cancel"),
                )
              ]
            )
          ],
        ],
      ),
    );
  }
}