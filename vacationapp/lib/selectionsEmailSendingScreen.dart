/*
*Ella Muro
*14 July 2026
*Selections Email Sending Screen
*/

//Imports section
import 'package:flutter/material.dart';
import 'selectionsEmailService.dart';

class SelectionsEmailSendingScreen extends StatefulWidget {
  const SelectionsEmailSendingScreen({super.key});

  @override
  State<SelectionsEmailSendingScreen> createState() => _SelectionsEmailSendingScreenState();

}

class _SelectionsEmailSendingScreenState extends State<SelectionsEmailSendingScreen> {

  //Instantiating SelectionsEmailService into an object
  SelectionsEmailService selectionsEmailService = SelectionsEmailService();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Selections Email Sending",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 40, 89, 113),
          ),
          onPressed: () async {
            await selectionsEmailService.emailSelections();
          },
          icon: Icon(Icons.send),
          label: Text("Email Selections File",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
          ),
        ),
      ),
    );
  }
}