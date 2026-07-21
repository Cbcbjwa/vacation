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
  bool obscureConfirmNewPassword = true;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  //Instantiating UserService class into an object
  UserService userService = UserService();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
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

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //Spacing
            SizedBox(height: 100),
            
              //Section header
              Column(
                children: [
                  Text(
                    "Personal Information",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
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
                  SizedBox(height: 15),

                  //User's phone number
                  Center(
                    child: Text(
                      Session.phoneNumber!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ]
              ),

            //Spacing
            SizedBox(height: 100),

            //Section header
            Center(
              child: Text(
                "Security",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ),

            //Spacing
            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                ),
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
                  cursorColor: Colors.blueGrey,
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "New Password",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2,
                      )
                    ),
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

              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  cursorColor: Colors.blueGrey,
                  controller: confirmNewPasswordController,
                  obscureText: obscureConfirmNewPassword,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmNewPassword = !obscureConfirmNewPassword;
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                    ),
                    onPressed: () async {
                      String newPassword = newPasswordController.text;
                      String confirmNewPassword = confirmNewPasswordController.text;

                      print("New Password: $newPassword");
                      print("Confirm New Password: $confirmNewPassword");

                      if(newPassword.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password cannot be empty")),
                        );
                        return;
                      }

                      if (newPassword != confirmNewPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }

                      String result = await userService.changePassword(userId: Session.userId!, newPassword: newPassword, confirmNewPassword: confirmNewPassword);
                    
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                    ),
                    onPressed: () {
                      setState(() {
                        showPasswordFields = false;
                      });
                    },
                    child: Text("Cancel"),
                  )
                ]
              ),
              //Spacing
              SizedBox(width: 15),
            ],
          ],
        ),
      )
    );
  }
}