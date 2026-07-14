/*
*Ella Muro
*14 July 2026
*Class to Handle Selections Emails
*/

//Imports section
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for sending emails
  Future<bool> emailSelections() async {
    print("SENDING SELECTIONS EMAIL..");

    try{

      final response = await http.post(
        Uri.parse("$baseUrl/emailSelections/deliverSelections"),

        headers: {
        "Content-Type": "application/json",
        },
      );

      if(response.statusCode == 200) {
        print("SELECTIONS EMAIL SENT SUCCESSFULLY");
        return true;
      } else {
        print("FAILED TO SEND SELECTIONS EMAIL: ${response.body}");
        return false;
      }
    } catch (error) {
      print("ERROR SENDING SELECTIONS EMAIL: $error");
      return false;
    }
  }
}