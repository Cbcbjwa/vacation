/*
*Ella Muro
*25 May 2026
*Repository to Hold the Master List of Sites
*/

//Imports section
import 'package:flutter/material.dart';
import 'site.dart';
import 'siteService.dart';

class SiteRepository {

  //Instantiating SiteService class into an object
  SiteService siteService = SiteService();
 

  //Initializing a master list of sites
  List<Site> sites = [];

  //Method to load sites
  Future<List<Site>> loadSiteRecords() async {
    sites = await siteService.getSites();

    print("SITES LENGTH: ${sites.length}");
    print("RAW SITES: $sites");

    return sites;
  }
}