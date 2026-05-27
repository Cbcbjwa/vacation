/*
*Ella Muro
*25 May 2026
*Class to Handle Sites
*/

//Imports section
import 'site.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SiteService {
  final String baseUrl = "http://10.0.2.2:3000";

  //Method for loading sites
  Future<List<Site>> getSites() async {
    final res = await http.get(Uri.parse("$baseUrl/sites"));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

   if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      print(res.body);

      return data.map((e) => Site.fromJson(e)).toList();
    }
    return [];
  }

  //Method for creating sites
  Future<bool> createSite({
    required String siteName,
    required int maxDocsOffPerWeek,
  }) async {

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
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for updating sites
  Future<bool> updateSite({
    required int siteId,
    required String siteName, 
    required int maxDocsOffPerWeek,
  }) async {
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
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }

  //Method for deleting a site
  Future<bool> deleteSiteRecord({

    required int siteId,

  }) async {
    print("DELETING SITE...");

    final res = await http.delete(
      Uri.parse("$baseUrl/sites/$siteId"),
    );
  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
  }
}