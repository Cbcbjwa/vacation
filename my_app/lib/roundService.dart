/*
*Ella Muro
*6 June 2026
*Class to Handle Rounds
*/

//Imports section
import 'round.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoundService {
  final String baseUrl = "http://10.0.2.2:3000";

  //Method for loading users
  Future<List<Round>> getRounds() async {
    final res = await http.get(Uri.parse("$baseUrl/rounds"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      print(res.body);

      return data.map((e) => Round.fromJson(e)).toList();
    }
    return [];
  }
}