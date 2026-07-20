/*
*Ella Muro
*25 May 2026
*Class to Handle Sites
*/

//Imports section
import 'site.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'connectivityService.dart';

class SiteService {
  final String baseUrl = "https://vacation-xhxd.onrender.com";

  //Method for loading sites
  Future<List<Site>> getSites() async {

    try {
      final res = await http.get(Uri.parse("$baseUrl/sites")).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if(res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        print(res.body);

        return data.map((e) => Site.fromJson(e)).toList();
      }
      return [];
    } catch (error) {
      print("GET SITES ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for creating sites
  Future<bool> createSite({
    required String siteName,
    required int maxDocsOffPerWeek,
  }) async {

    try {

      print ("SENDING CREATE SITE REQUEST");

      final res = await http.post(
        Uri.parse("$baseUrl/sites/addSite"),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "siteName": siteName,
          "maxDocsOffPerWeek": maxDocsOffPerWeek,
        }),
      ).timeout(Duration(seconds: 15));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("CREATE SITE ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for updating sites
  Future<bool> updateSite({
    required int siteId,
    required String siteName, 
    required int maxDocsOffPerWeek,
  }) async {

    try {
        print ("UPDATING SITE");

        final res = await http.put(
          Uri.parse("$baseUrl/sites/update"),

          headers: {
            "Content-Type": "application/json",
          },

          body: jsonEncode({
            "siteId": siteId,
            "siteName": siteName,
            "maxDocsOffPerWeek": maxDocsOffPerWeek,
          }),
        ).timeout(Duration(seconds: 15));

        print("STATUS: ${res.statusCode}");
        print("BODY: ${res.body}");

        return res.statusCode == 200;
    } catch (error) {
      print("UPDATE SITE ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }

  //Method for deleting a site
  Future<bool> deleteSiteRecord({

    required int siteId,

  }) async {

    try {
      print("DELETING SITE...");

      final res = await http.delete(
        Uri.parse("$baseUrl/sites/$siteId"),
      ).timeout(Duration(seconds: 15));
      
      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (error) {
      print("DELETE SITE ERROR: $error");
      ConnectivityService.instance.connectionFailed();
      throw Exception("No internet connection");
    }
  }
}