/*
*Ella Muro
*19 June 2026
*Class to Handle Emails
*/

//Imports section
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'connectivityService.dart';

class EmailService {
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for sending emails
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String text
  }) async {
    print("SENDING EMAIL..");

    try{
      final response = await http.post(
        Uri.parse("$baseUrl/email/deliverEmail"),

        headers: {
        "Content-Type": "application/json",
        },

        body: jsonEncode({
          "to": to,
          "subject": subject,
          "text": text
        }),
      );

      if(response.statusCode == 200) {
        print("EMAIL SENT SUCCESSFULLY");
        return true;
      } else {
        print("FAILED TO SEND EMAIL: ${response.body}");
        return false;
      }
    } catch (error) {
      ConnectivityService.instance.connectionFailed();
      return false;
    }
  }
}